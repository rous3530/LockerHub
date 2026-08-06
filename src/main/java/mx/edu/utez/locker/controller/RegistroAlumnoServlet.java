package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoAlumno;
import mx.edu.utez.locker.model.Alumno;

import java.io.IOException;

@WebServlet(name = "RegistroAlumnoServlet", value = "/registro-alumno")
public class RegistroAlumnoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String matricula = request.getParameter("matricula");
        String nombres = request.getParameter("nombres");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String idCarrera = request.getParameter("idCarrera");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        // Construir el objeto Alumno
        Alumno alumno = new Alumno();
        alumno.setMatricula(matricula);
        alumno.setNombres(nombres);
        alumno.setApellidoPaterno(apellidoPaterno);
        alumno.setApellidoMaterno(apellidoMaterno);
        alumno.setIdCarrera(idCarrera);
        alumno.setCorreo(correo);
        alumno.setContrasena(contrasena);

        DaoAlumno dao = new DaoAlumno();
        boolean guardado = dao.registrar(alumno);

        if (guardado) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/sesion/registro.jsp?status=error");
        }
    }
}