int width=600,height=600;

class ball{
    int radius;
    int mass;
    PVector pos;
    PVector vel;
    PVector accl;
    PVector force;
    ball(int tr,int m,PVector t){
        radius=tr;
        mass=m;
        pos=t;
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
        fill(255);
        noStroke();
        ellipse(pos.x,pos.y,2*radius,2*radius);
    }
    
};

ball b1=new ball(20,10,new PVector(50,50));
void setup(){
    size(600,600);
    b1.vel.set(5,0);
    b1.updateForce(new PVector(0,b1.mass));
}

void draw(){
    background(100);
    b1.update();
    b1.draw();
}