package mx.edu.utez.locker.model;

public class EdificioDto {
    private int idEdificio;
    private String nombre;

    public EdificioDto() {
    }

    public EdificioDto(int idEdificio, String nombre) {
        this.idEdificio = idEdificio;
        this.nombre = nombre;
    }

    public int getIdEdificio() {
        return idEdificio;
    }

    public void setIdEdificio(int idEdificio) {
        this.idEdificio = idEdificio;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}