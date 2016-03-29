final int width=600,height=600;
int mouseWeight=8;
float forceConst=150;
float massDensity=0.2;
int maxBalls=(int)(0.00015*width*height);
float maxR=60,minR=5;
float maxV=7,minV=0;
float epsilon=0.000001;

class ball{
    float radius;
    float mass;
    color inside;
    PVector pos;
    PVector vel;
    PVector accl;
    PVector force;
    ball(){
        radius=random(minR,maxR);
        pos=new PVector(0,0);;
        mass=random(massDensity*radius);
        inside=color(random(256),random(256),random(256));
        vel=new PVector(0,0);
        accl=new PVector(0,0);
        force=new PVector(0,0);
    }
    ball(float tr,float m,PVector t,color _inside){
        radius=tr;
        mass=m;
        pos=t;
        inside=_inside;
        vel=new PVector(0,0);
        accl=new PVector(0,0);
        force=new PVector(0,0);
    }
    void updateForce(PVector f){
        force.set(f);
    }
    void updateAccl(PVector f){
        accl.set(f);
    }
    void updateVel(PVector f){
        vel.set(f);
    }
    void updatePos(PVector f){
        pos.set(f);
    }
    void bounceWall(){
        if(pos.y>height-radius){
            vel.y=-vel.y;
            pos.y=height-radius;
        }
        if(pos.y<radius){
            vel.y=-vel.y;
            pos.y=radius;
        }
        if(pos.x>width-radius){
            vel.x=-vel.x;
            pos.x=width-radius;
        }
        if(pos.x<radius){
            vel.x=-vel.x;
            pos.x=radius;
        }
    }
    void update(){
        accl.set(PVector.div(force,mass)); 
        vel.add(accl);
        pos.add(vel);
        bounceWall();
    }
    void draw(){
        fill(inside);
        strokeWeight(4);
        stroke(0,0,0);
        ellipse(pos.x,pos.y,2*radius,2*radius);
    }
    
};


 void addBallAt(ArrayList<ball> blist,int x,int y){
        if(blist.size()<=maxBalls){
        ball b=new ball();
        b.pos.set(x,y);
        b.vel.set(random(minV,maxV),random(minV,maxV));
        blist.add(b);
        }
    }
   
//ball[] b=new ball[nBalls];
//void createBalls(ball b[],int n){
//    for(int i=0;i<n;i++){
//        float r=random(minR,maxR);
//        color c=color(random(256),random(256),random(256));
//        b[i]=new ball(r,r*massDensity,new PVector(random(r,width-r),random(r,height-r)),c);
//        b[i].vel.set(random(minV,maxV),random(minV,maxV));
//    }
//}
void setup(){
    size(600,600);
}

PVector ForcetoMouse(ball b){
    PVector p=PVector.sub(new PVector(mouseX,mouseY),b.pos);
    if(p.magSq()==0){
        p.setMag(0);
        return p;
    }
    p.setMag(forceConst * mouseWeight*b.mass/p.magSq());
    return p;
}
PVector distBtwn(ball a ,ball b){
    return PVector.sub(b.pos,a.pos);
}
boolean detCol(ball a, ball b){
    PVector d=distBtwn(a,b);
    if (d.mag()<(a.radius+b.radius)){
        d.normalize();
        d.mult((a.radius+b.radius));
        b.pos=PVector.add(a.pos,d);
        return true;
    }
    else return false;
}
PVector compute2DVel(ball a, ball b){
    // if(distBtwn(a,b)<epsilon)return a.vel;
    return PVector.sub(a.vel,PVector.mult(PVector.sub(a.pos,b.pos),((2*b.mass)/(a.mass+b.mass)*PVector.dot(PVector.sub(a.vel,b.vel),PVector.sub(a.pos,b.pos))/(distBtwn(a,b).mag()*distBtwn(a,b).mag()))));
}
void afterCol(ball a,ball b){
    PVector aVel_,bVel_;
    aVel_=compute2DVel(a,b);
    bVel_=compute2DVel(b,a);
    a.vel=aVel_;
    b.vel=bVel_;
}
void checkForCol(ArrayList<ball> blist){
    int n=blist.size();
    for(int i=0;n>=2 && i<n-1;i++){
        for(int j=i+1;j<n;j++){
            if(detCol(blist.get(i),blist.get(j))){
                afterCol(blist.get(i),blist.get(j));
            }
        }
    }
}
void updateAllBalls(ArrayList<ball>blist){
    for(ball i : blist){
      i.update();
      i.draw();
    }
}

ArrayList<ball> blist=new ArrayList <ball>();
void draw(){
    background(255);
    checkForCol(blist);
    updateAllBalls(blist);
    }
    
void mouseReleased(){
     addBallAt(blist,mouseX,mouseY);
     println(blist.size());
}
