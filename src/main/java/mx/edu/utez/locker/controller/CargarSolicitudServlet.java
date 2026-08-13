package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoSolicitud;
import mx.edu.utez.locker.model.EdificioDto;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CargarSolicitudServlet", value = "/solicitud-form")
public class CargarSolicitudServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DaoSolicitud dao = new DaoSolicitud();
        List<EdificioDto> listaEdificios = dao.obtenerEdificios();

        System.out.println("Edificios cargados para el JSP: " + listaEdificios.size());

        // Pasar la lista como atributo de la petición
        request.setAttribute("listaEdificios", listaEdificios);

        // Despachar hacia la vista JSP
        request.getRequestDispatcher("/alumno/solicitudLocker.jsp").forward(request, response);
    }
}