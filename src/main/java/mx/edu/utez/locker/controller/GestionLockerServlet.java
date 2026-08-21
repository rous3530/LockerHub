package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.Administrador;
import mx.edu.utez.locker.model.CasilleroDto;
import mx.edu.utez.locker.model.EdificioDto; // Asegúrate de importar tu DTO de casilleros o la clase que uses

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionLockerServlet", value = "/admin/gestionLocker")
public class GestionLockerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validación de sesión y rol de Administrador
        HttpSession sesion = request.getSession(false);
        Administrador admin = (sesion != null) ? (Administrador) sesion.getAttribute("usuario") : null;

        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/views/sesion/IniciarSesion.jsp?error=sin_permiso");
            return;
        }

        try {
            DaoSolicitud dao = new DaoSolicitud();

            // 2. Cargar los datos necesarios desde los DAOs
            List<EdificioDto> listaEdificios = dao.obtenerEdificios();
             List<CasilleroDto> listaCasilleros = dao.obtenerTodosLosCasilleros(); // Descomenta e implementa según tu método real

            // 3. Enviar los atributos al request
            request.setAttribute("listaEdificios", listaEdificios);
            request.setAttribute("listaCasilleros", listaCasilleros);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4. Redirigir hacia la vista JSP ubicada en tu carpeta protegida/views
        request.getRequestDispatcher("/views/admin/gestionLocker.jsp").forward(request, response);
    }
}