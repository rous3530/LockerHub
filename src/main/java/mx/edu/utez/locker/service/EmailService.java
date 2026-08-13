package mx.edu.utez.locker.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    private static final String REMITENTE = "e01384359@gmail.com"; // Tu correo
    private static final String CLAVE_APP = "kuukwecayomkrudo"; // Contraseña de aplicación Gmail

    public static boolean enviarToken(String destinatario, String token) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(REMITENTE, CLAVE_APP);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(REMITENTE, "LockerHub Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject("Código de recuperación de contraseña - LockerHub");

            String contenido = "<h2>Recuperación de Contraseña - LockerHub</h2>"
                    + "<p>Tu código de verificación para restablecer la contraseña es:</p>"
                    + "<h1 style='color: #0d6efd; letter-spacing: 4px;'>" + token + "</h1>"
                    + "<p>Este código expira en 15 minutos.</p>";

            message.setContent(contenido, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}