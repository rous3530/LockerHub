package mx.edu.utez.locker.model;

public class Carrera {
    private String idCarrera;
    private String nombre;

    public Carrera() {}

    public Carrera(String idCarrera, String nombre) {
        this.idCarrera = idCarrera;
        this.nombre = nombre;
    }

    public String getIdCarrera() { return idCarrera; }
    public void setIdCarrera(String idCarrera) { this.idCarrera = idCarrera; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
}