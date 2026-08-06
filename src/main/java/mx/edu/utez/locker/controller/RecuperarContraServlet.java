package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mx.edu.utez.locker.dao.DaoAlumno;
import mx.edu.utez.locker.service.EmailService;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "RecuperarContraServlet", value = "/recuperar-contrasena")
public class RecuperarContraServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        DaoAlumno dao = new DaoAlumno();
        String jspPath = "/views/sesion/recuperarContra.jsp";

        if ("solicitar".equalsIgnoreCase(accion)) {
            String correo = request.getParameter("correo");

            // Generar token numérico de 6 dígitos
            String token = String.format("%06d", new Random().nextInt(999999));

            if (dao.guardarTokenRecuperacion(correo, token)) {
                EmailService.enviarToken(correo, token);
                response.sendRedirect(request.getContextPath() + jspPath + "?step=2&correo=" + correo);
            } else {
                response.sendRedirect(request.getContextPath() + jspPath + "?status=correo_no_encontrado");
            }

        } else if ("verificar".equalsIgnoreCase(accion)) {
            String correo = request.getParameter("correo");
            String token = request.getParameter("token");

            if (dao.validarToken(correo, token)) {
                response.sendRedirect(request.getContextPath() + jspPath + "?step=3&correo=" + correo + "&token=" + token);
            } else {
                response.sendRedirect(request.getContextPath() + jspPath + "?step=2&correo=" + correo + "&status=token_invalido");
            }

        } else if ("restablecer".equalsIgnoreCase(accion)) {
            String correo = request.getParameter("correo");
            String token = request.getParameter("token");
            String nuevaContrasena = request.getParameter("nuevaContrasena");

            if (dao.validarToken(correo, token) && dao.actualizarContrasena(correo, nuevaContrasena)) {
                response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?status=pass_updated");
            } else {
                response.sendRedirect(request.getContextPath() + jspPath + "?status=error_general");
            }
        }
    }
}