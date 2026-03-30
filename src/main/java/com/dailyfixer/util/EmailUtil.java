package com.dailyfixer.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;


public class EmailUtil {
    public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
        final String fromEmail = "dailyfixerapp@gmail.com"; // Your Gmail
        final String password = "hewi waoe yftl zmej"; // Your Gmail App Password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(body, "text/html");

        Transport.send(message);
    }
}

