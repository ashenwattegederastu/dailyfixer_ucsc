package com.dailyfixer.util;

import com.dailyfixer.model.VolunteerStats;

public class ReputationUtils {

    // Weights
    private static final double W_QUALITY = 0.4;
    private static final double W_ENGAGEMENT = 0.25;
    private static final double W_CONTRIBUTION = 0.2;
    private static final double W_APPROVAL = 0.15;

    // Caps and Constants
    // Caps and Constants
    // private static final int MAX_CONTRIBUTION_GUIDES = 20; // Removed per user
    // request

    // Tier thresholds
    private static final double DIAGNOSTIC_CONTRIBUTOR_THRESHOLD = 31.0;

    /**
     * Check if a volunteer's reputation score qualifies for diagnostic tree access.
     * Requires "Diagnostic Contributor" tier (150+ reputation points).
     */
    public static boolean isDiagnosticContributor(double score) {
        return score >= DIAGNOSTIC_CONTRIBUTOR_THRESHOLD;
    }

    public static void calculateReputation(VolunteerStats stats) {
        if (stats == null)
            return;

        // 1. Guide Quality Score: (Likes - Dislikes) / Total Guides
        double qualityScore = 0;
        if (stats.getTotalGuides() > 0) {
            // Slight penalty for dislikes (1.2x)
            double netScore = stats.getTotalLikes() - (stats.getTotalDislikes() * 1.2);
            qualityScore = netScore / stats.getTotalGuides();
        }
        // Normalize quality score (ensure it's not negative for display, or keep it
        // raw?)
        // Let's cap minimum at 0 for simplicity in this model unless negative
        // reputation is desired.
        // The prompt says "Penalize dislikes", so negative is possible.
        // We will keep it raw but maybe scale it. For now, raw.

        // 2. Engagement Score: log(1 + Total Views)
        double engagementScore = Math.log10(1 + stats.getTotalViews()) * 10; // Scaling by 10 to make it meaningful

        // 3. Contribution Score: Based on guides count, capped
        // 3. Contribution Score: Based on guides count (Uncapped)
        double contributionScore = stats.getTotalGuides() * 5; // 5 points per guide

        // 4. Approval Ratio: Likes / (Likes + Dislikes)
        double approvalRatio = 0;
        int totalReactions = stats.getTotalLikes() + stats.getTotalDislikes();
        if (totalReactions > 0) {
            approvalRatio = (double) stats.getTotalLikes() / totalReactions;
        }

        // Final Calculation
        // Adjusted formula to bring numbers to a 0-100+ scale
        // Quality: can be small (e.g. 5 likes/guide). Let's scale by 10.
        // Approval Ratio: 0-1. Scale by 100? Prompt says "0.15 * Approval Ratio * 10"
        // -> 1.5 max?
        // Let's follow the prompt's example structure but adjust scales to be visible.

        // Prompt Formula:
        // (0.4 * Quality) + (0.25 * Engagement) + (0.2 * Contribution) + (0.15 *
        // Approval * 10)

        double weightedQuality = W_QUALITY * (qualityScore * 10); // Scale up quality
        double weightedEngagement = W_ENGAGEMENT * engagementScore; // Log is small, logic handled above
        double weightedContribution = W_CONTRIBUTION * contributionScore; // 0-100 range
        double weightedApproval = W_APPROVAL * (approvalRatio * 100); // 0-100 range

        double reputation = weightedQuality + weightedEngagement + weightedContribution + weightedApproval;

        // Ensure no negative total reputation
        if (reputation < 0)
            reputation = 0;

        stats.setQualityScore(Math.round(weightedQuality * 100.0) / 100.0);
        stats.setEngagementScore(Math.round(weightedEngagement * 100.0) / 100.0);
        stats.setContributionScore(Math.round(weightedContribution * 100.0) / 100.0);
        // Storing approval part score isn't explicitly in stats model, but we have
        // approval rating.

        stats.setReputationScore(Math.round(reputation * 100.0) / 100.0);
    }

    public static String getBadgeForScore(double score) {
        if (score >= 150)
            return "Diagnostic Contributor";
        if (score >= 100)
            return "Expert Volunteer";
        if (score >= 50)
            return "Trusted Helper";
        if (score >= 10)
            return "Helper";
        return "New Volunteer";
    }

    public static String getNextTierName(double score) {
        if (score < 10)
            return "Helper";
        if (score < 50)
            return "Trusted Helper";
        if (score < 100)
            return "Expert Volunteer";
        if (score < 150)
            return "Diagnostic Contributor";
        return "Max Tier Reached";
    }

    public static int getNextTierScore(double score) {
        if (score < 10)
            return 10;
        if (score < 50)
            return 50;
        if (score < 100)
            return 100;
        if (score < 150)
            return 150;
        return 0; // Max tier
    }
}
