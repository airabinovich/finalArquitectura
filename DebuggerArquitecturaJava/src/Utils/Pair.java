package Utils;

public class Pair<L,R> {
    private L l;
    private R r;
    public Pair(L l, R r){
        this.l = l;
        this.r = r;
    }
    public L getFst(){ return l; }
    public R getSnd(){ return r; }
    public void setFst(L l){ this.l = l; }
    public void setSnd(R r){ this.r = r; }
}