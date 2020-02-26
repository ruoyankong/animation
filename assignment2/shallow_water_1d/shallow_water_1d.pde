import java.util.*;
Camera camera;
int nx= 41;
float dx;
float h[] = new float[nx];
float uh[] = new float[nx];
float totlen= nx*dx;
float hm[] = new float[nx];
float uhm[] = new float[nx];
float g = 9.8;
float damp = 0.1;
//float dt = 0.02;
float x_length = 1.0;
float t_length = 20;

float[] x;
int nt = 1000;
float dt = 0.002;
float sim_dt = 0.0002;

public void settings() {
  size( 1000, 1000, P3D );
  camera = new Camera();
}
void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
void setup() {

  for (int i = 0;i<h.length;i++) h[i] = 0.0;
  for (int i = 0;i<uh.length;i++) uh[i] = 0.0;
  for (int i = 0;i<hm.length;i++) hm[i] = 0.0;
  for (int i = 0;i<uhm.length;i++) uhm[i] = 0.0;
  x = r8vec_linspace_new ( nx, 0.0, x_length); //<>//
  dx = x_length/ ( float) ( nx - 1 );
  //sim_dt = t_length/ ( float) ( nt );
  
  initial_conditions ( nx, nt, x, 0, h, uh );
  h[0] = h[h.length-2];
  h[h.length-1]=h[1];
  uh[0] = uh[uh.length-2];
  uh[uh.length-1] = uh[1];
  
}

void waveEquation(float dt){

    for (int i = 0; i < nx - 1; i++ )
    {
      hm[i] = ( h[i] + h[i+1] ) / 2.0 
        - ( dt / 2.0 ) * ( uh[i+1] - uh[i] ) / dx;
    }
    for (int i = 0; i < nx - 1; i++ )
    { //<>//
      uhm[i] = ( uh[i] + uh[i+1] ) / 2.0 
        - ( dt / 2.0 ) * ( 
          uh[i+1] * uh[i+1] / h[i+1] + 0.5 * g * h[i+1] * h[i+1]
        - uh[i] * uh[i]  / h[i] - 0.5 * g * h[i] * h[i] ) / dx;
    }
    for (int i = 1; i < nx - 1; i++ )
    {
      h[i] = h[i] 
        - dt * ( uhm[i] - uhm[i-1] ) / dx;
    }
    for (int i = 1; i < nx-1; i++ )
    {
      uh[i] = uh[i] 
        - dt * ( damp*uh[i+1]+
          uhm[i] * uhm[i]  / hm[i] + 0.5 * g * hm[i] * hm[i]
        - uhm[i-1] * uhm[i-1]  / hm[i-1] - 0.5 * g * hm[i-1] * hm[i-1] ) / dx;
    }
  //for (int i=0;i<nx-2;i++){
  //  h[i+1]= h[i+1]-dt*(uhm[i+1]-uhm[i])/dx;
  //  uh[i+1] = uh[i+1]-dt*(damp*uh[i+1]+sqrt(uhm[i+1])/hm[i+1]+0.5*g*sqrt(hm[i+1])-
  //  sqrt(uhm[i])/hm[i]-0.5*g*sqrt(hm[i]))/dx;
  //}
  h[0] = h[h.length-2];
  h[h.length-1]=h[1];
  uh[0] = uh[uh.length-2];
  uh[uh.length-1] = uh[1];  
}

void update(float dt){
  for (int i=0;i<(int)(dt/sim_dt);i++){
    waveEquation(sim_dt); //<>//
  }
}
float x1,x2;
PVector v1,v2,n;
float left = 0;
float w = 10;
void draw(){
  System.out.println("frame rate: "+frameRate);
  background(255);
  camera.Update( dt);
  update(dt);
  
  for (int i =0;i<nx-1;i++){
    x1 = left+i*dx;
    x2 = left +(i+1)*dx;
    v1 = new PVector(x2-x1, h[i+1]-h[i], 0); //<>//
    v2 = new PVector(0, 0, -1);
    n = v1.cross(v2);
    stroke(176, 196, 222);
    beginShape(TRIANGLE_STRIP);
    //normal(n.x, n.y, n.z);
    vertex(x1, h[i], 0);
    vertex(x2, h[i+1], 0);
    vertex(x2, h[i+1], -w);
    vertex(x1, h[i], -w);
    endShape(CLOSE);
  }
  
}

float[] r8vec_linspace_new ( int n, float a_first, float a_last )
//
{
  float a[] = new float[n];
  int i;

  if ( n == 1 )
  {
    a[0] = (( a_first + a_last ) / 2.0);
  }
  else
  {
    for ( i = 0; i < n; i++ )
    {
      a[i] = (( (float) ( n - 1 - i ) * a_first 
             + (float) (         i ) * a_last ) 
             / (float) ( n - 1     ));
    }
  }
  return a;
}

void initial_conditions ( int nx, int nt, float x[], float t, float h[], 
  float uh[] )
{
  int i;
  float pi = 3.141592653589793;

  for ( i = 0; i < nx; i++ )
  {
    h[i] = 2.0 + sin ( 2.0 * pi * x[i] );
  }
  for ( i = 0; i < nx; i++ )
  {
    uh[i] = 0.0;
  }
  return;
}
