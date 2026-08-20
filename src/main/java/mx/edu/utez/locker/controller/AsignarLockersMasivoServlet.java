package mx.edu.utez.locker.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.edu.utez.locker.dao.DaoSolicitud;

import java.io.IOException;

@WebServlet(name = "AsignarLockersMasivoServlet", value = "/asignar-lockers-masivo")
public class AsignarLockersMasivoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== INICIANDO ASIGNACIÓN MASIVA DE LOCKERS ===");

        DaoSolicitud dao = new DaoSolicitud();
        boolean exito = dao.asignarLockersAutomaticamente();

        if (exito) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudieron asignar los lockers o no hay disponibles.");
        }
    }
}