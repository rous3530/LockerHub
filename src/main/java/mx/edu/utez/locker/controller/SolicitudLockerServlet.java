package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Alumno;
import java.io.IOException;

@WebServlet(name = "SolicitudLockerServlet", value = "/solicitud-locker")
public class SolicitudLockerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. Validar sesión
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        // 2. Obtener ID del alumno
        Alumno alumno = (Alumno) session.getAttribute("usuario");
        int idAlumno = alumno.getIdAlumno();

        // 3. Recibir parámetros del JSP
        String idEdificio = request.getParameter("idEdificio");
        String cuatrimestre = request.getParameter("cuatrimestre");
        String grupo = request.getParameter("grupo");

        String idPeriodoStr = request.getParameter("idPeriodoCuatri");
        int idPeriodoCuatri = (idPeriodoStr != null) ? Integer.parseInt(idPeriodoStr) : 1;

        // 4. Guardar en BD (pasamos 'null' en el locker)
        DaoSolicitud dao = new DaoSolicitud();
        boolean exito = dao.registrarSolicitud(idAlumno, idEdificio, null, idPeriodoCuatri, grupo, cuatrimestre);

        // 5. Redirigir
        if (exito) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/solicitarLocker.jsp?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/alumno/solicitarLocker.jsp?status=error");
        }
    }
}