package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.ConnectionOracle;
import mx.edu.utez.locker.model.Carrera;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DaoCarrera {

    public List<Carrera> obtenerTodas() {
        List<Carrera> lista = new ArrayList<>();
        String sql = "SELECT ID_CARRERA, NOMBRE FROM CARRERA ORDER BY NOMBRE ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Carrera c = new Carrera();
                c.setIdCarrera(rs.getString("ID_CARRERA"));
                c.setNombre(rs.getString("NOMBRE"));
                lista.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}