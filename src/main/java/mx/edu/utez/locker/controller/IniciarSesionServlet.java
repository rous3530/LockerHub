package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoAlumno;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.Alumno;

import java.io.IOException;

@WebServlet(name = "IniciarSesionServlet", value = "/iniciar-sesion")
public class IniciarSesionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        DaoAlumno dao = new DaoAlumno();

        // dao.iniciarSesion ahora retorna Object (Administrador, Alumno o null)
        Object usuario = dao.iniciarSesion(correo, contrasena);

        if (usuario != null) {
            HttpSession session = request.getSession();

            // Guardar el usuario y validar el tipo de perfil registrado
            if (usuario instanceof Administrador) {
                Administrador admin = (Administrador) usuario;
                session.setAttribute("usuario", admin);
                session.setAttribute("rol", admin.getRol());

                // Redirección al módulo de administración
                response.sendRedirect(request.getContextPath() + "/views/admin/inicio.jsp");

            } else if (usuario instanceof Alumno) {
                Alumno alumno = (Alumno) usuario;
                session.setAttribute("usuario", alumno);
                session.setAttribute("rol", alumno.getRol());

                // Redirección al módulo de alumno
                response.sendRedirect(request.getContextPath() + "/views/alumno/inicio.jsp");
            }
        } else {
            // Si las credenciales no coincidieron en ninguna tabla
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?status=auth_error");
        }
    }
}