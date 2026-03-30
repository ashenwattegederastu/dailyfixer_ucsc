package com.dailyfixer.listener;

import com.dailyfixer.job.DeliveryTimeoutJob;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Bootstraps background jobs when the web application starts.
 * Registered automatically via @WebListener — no web.xml entry needed.
 * Jobs started here:
 *  - DeliveryTimeoutJob: runs every 15 minutes, cancels delivery assignments
 *    that have been PENDING for more than 48 hours and initiates buyer refunds.
 */
@WebListener
public class AppStartupListener implements ServletContextListener {

    /** How often the timeout check runs (minutes). */
    private static final int CHECK_INTERVAL_MINUTES = 2;

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "delivery-timeout-job");
            t.setDaemon(true); // Don't prevent JVM shutdown
            return t;
        });

        // Initial delay of 2 minutes lets the app fully start up before the first run
        scheduler.scheduleAtFixedRate(
                new DeliveryTimeoutJob(),
                2,
                CHECK_INTERVAL_MINUTES,
                TimeUnit.MINUTES
        );

        System.out.println("[AppStartupListener] DeliveryTimeoutJob scheduled — runs every "
                + CHECK_INTERVAL_MINUTES + " minutes.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            System.out.println("[AppStartupListener] Scheduler shut down.");
        }
    }
}
