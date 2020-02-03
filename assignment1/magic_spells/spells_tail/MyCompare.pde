class MyCompare implements Comparator<Particle>{

    public int compare(Particle p1, Particle p2) {
        float p1x = p1.getPosX();
        float p2x = p2.getPosX();
        return Float.compare(p1x,p2x);
    }
}
