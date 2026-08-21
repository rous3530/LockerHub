package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionLockerServlet", value = "/admin/gestion-lockers")
public class GestionLockerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validación de sesión y rol de administrador
        HttpSession sesion = request.getSession(false);
        Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        try {
            DaoSolicitud dao = new DaoSolicitud();

            // 2. Obtener la lista de edificios desde la BD para el menú desplegable
            // (Asegúrate de tener un método en tu DAO que devuelva los edificios, o ajusta según tu clase DAO existente)
            // List<Edificio> listaEdificios = dao.obtenerEdificios();
            // request.setAttribute("listaEdificios", listaEdificios);

            // 3. Obtener la lista inicial de casilleros
            // List<DaoSolicitud.LockerDto> listaCasilleros = dao.obtenerTodosLosLockers();
            // request.setAttribute("listaCasilleros", listaCasilleros);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4. Redirigir a la vista JSP
        request.getRequestDispatcher("/views/admin/gestionLocker.jsp").forward(request, response);
    }
}