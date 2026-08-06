package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoAlumnoPortal;
import mx.edu.utez.locker.model.Alumno;
import mx.edu.utez.locker.model.AlumnoDashboardDto;
import mx.edu.utez.locker.model.SolicitudDto;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "InicioAlumnoServlet", value = "/alumno/inicio")
public class InicioAlumnoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Alumno usuario = (session != null) ? (Alumno) session.getAttribute("usuario") : null;

        // Validar que el usuario sea alumno autenticado
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp");
            return;
        }

        DaoAlumnoPortal dao = new DaoAlumnoPortal();
        AlumnoDashboardDto dashboard = dao.obtenerDashboardAlumno(usuario.getIdAlumno());
        List<SolicitudDto> historial = dao.obtenerHistorialReciente(usuario.getIdAlumno());

        request.setAttribute("dashboard", dashboard);
        request.setAttribute("historial", historial);

        request.getRequestDispatcher("/views/alumno/inicioAlumno.jsp").forward(request, response);
    }
}