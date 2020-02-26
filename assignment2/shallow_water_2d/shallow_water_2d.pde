import java.util.*;
Camera camera;
import queasycam.*;
int nx= 100;
float dx;
float h[][] = new float[nx][nx];
float uh[][] = new float[nx][nx];
float vh[][] = new float[nx][nx];
float hmx[][] = new float[nx][nx];
float uhmx[][] = new float[nx][nx];
float vhmx[][] = new float[nx][nx];
float hmz[][] = new float[nx][nx];
float uhmz[][] = new float[nx][nx];
float vhmz[][] = new float[nx][nx];
float g = 9.8;
float damp = 0.1;
//float dt = 0.02;
float x_length = 10;
float t_length = 20;

float[][] x, z;
int nt = 1000;
float dt = 0.002;
float sim_dt = 0.00005;

public void settings() {
  size( 1000, 1000, P3D );
  //camera = new Camera();
  //camera.position = new PVector(0, 0, 50);
}
//void keyPressed()
//{
//  camera.HandleKeyPressed();
//}

//void keyReleased()
//{
//  camera.HandleKeyReleased();
//}
QueasyCam cam;
void setup() {
  cam = new QueasyCam(this);
  cam.position = new PVector(10, -20, -20);
  cam.sensitivity = 1;   
  //cam = new PeasyCam(this, 120);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(2000);
  for (int i = 0;i<nx;i++)
    for (int j = 0; j<nx;j++){
      h[i][j] = 0.0;
      uh[i][j] = 0.0;
      vh[i][j] = 0.0;
      hmx[i][j] = 0.0;
      uhmx[i][j] = 0.0;
      vhmx[i][j] = 0.0;
      hmz[i][j] = 0.0;
      uhmz[i][j] = 0.0;
      vhmz[i][j] = 0.0;
    }
  x = r8col_linspace_new ( nx, 0.0, x_length);
  z = r8vec_linspace_new ( nx, 0.0, x_length);
  dx = x_length/ ( float) ( nx - 1 );
  //sim_dt = t_length/ ( float) ( nt );
  
  initial_conditions ( nx, nt, x, z, 0, h, uh, vh );
  boundary_conditions(h, uh, vh);

  
}

void boundary_conditions(float[][] h, float[][] uh, float[][] vh){
  for (int i=1; i<nx-1; i++){
      h[i][0] = h[i][1];
      h[i][nx-1]=h[i][nx-2];
      uh[i][0] = -uh[i][1];
      uh[i][nx-1] = -uh[i][nx-2];
      h[0][i] = h[1][i];
      h[nx-1][i]=h[nx-2][i];
      uh[0][i] = -uh[1][i];
      uh[nx-1][i] = -uh[nx-2][i];
  }
  
  h[0][0] = 0.5*(h[0][1]+h[1][0]);
  h[0][nx-1] = 0.5*(h[0][nx-2]+h[1][nx-1]);
  h[nx-1][0] = 0.5*(h[nx-2][0]+h[nx-1][1]);
  h[nx-1][nx-1] = 0.5*(h[nx-2][nx-1]+h[nx-1][nx-2]);
  
  uh[0][0] = uh[0][1];
  uh[nx-1][0] = uh[nx-1][1];
  uh[0][nx-1] = uh[0][nx-2];
  uh[nx-1][nx-1] = uh[nx-1][nx-2];
  
  vh[0][0] = vh[1][0]; 
  vh[nx-1][0] = vh[nx-2][0];  
  vh[0][nx-1] = vh[1][nx-1];  
  vh[nx-1][nx-1] = vh[nx-2][nx-1];

}

void waveEquation(float dt){
    for (int i = 0; i < nx; i++ )
    for (int j = 0; j < nx - 1; j++ )
    {
      hmx[i][j] = ( h[i][j] + h[i][j+1] ) / 2.0 
        - ( dt / 2.0 ) * ( uh[i][j+1] - uh[i][j] ) / dx;
      uhmx[i][j] = ( uh[i][j] + uh[i][j+1] ) / 2.0 
        - ( dt / 2.0 ) * ( 
          uh[i][j+1] * uh[i][j+1] / h[i][j+1] + 0.5 * g * h[i][j+1] * h[i][j+1]
        - uh[i][j] * uh[i][j]  / h[i][j] - 0.5 * g * h[i][j] * h[i][j] ) / dx;
      vhmx[i][j] = ( vh[i][j] + vh[i][j+1] ) / 2.0 
        - ( dt / 2.0 ) * ( 
          vh[i][j+1] * vh[i][j+1] / h[i][j+1]
        - vh[i][j] * vh[i][j]  / h[i][j]) / dx;
    }
    for (int i = 0; i < nx - 1; i++ )
    for (int j = 0; j < nx; j++ )
    {
      hmz[i][j] = ( h[i][j] + h[i+1][j] ) / 2.0 
        - ( dt / 2.0 ) * ( uh[i+1][j] - uh[i][j] ) / dx;
      uhmz[i][j] = ( uh[i][j] + uh[i+1][j] ) / 2.0 
        - ( dt / 2.0 ) * ( 
          uh[i+1][j] * uh[i+1][j] / h[i+1][j]
        - uh[i][j] * uh[i][j]  / h[i][j]) / dx;
      vhmz[i][j] = ( vh[i][j] + vh[i+1][j] ) / 2.0 
        - ( dt / 2.0 ) * ( 
          vh[i+1][j] * vh[i+1][j] / h[i+1][j] + 0.5 * g * h[i+1][j] * h[i+1][j]
        - vh[i][j] * vh[i][j]  / h[i][j] - 0.5 * g * h[i][j] * h[i][j] ) / dx;
    }
    for (int i = 0; i < nx; i++ )
    for (int j = 1; j < nx-1; j++)
    {
      h[i][j] = h[i][j] 
        - dt * ( uhmx[i][j] - uhmx[i][j-1] ) / dx;
      uh[i][j] = uh[i][j] 
        - dt * ( damp*uh[i][j]+
          uhmx[i][j] * uhmx[i][j]  / hmx[i][j] + 0.5 * g * hmx[i][j] * hmx[i][j]
        - uhmx[i][j-1] * uhmx[i][j-1]  / hmx[i][j-1] - 0.5 * g * hmx[i][j-1] * hmx[i][j-1] ) / dx;
      vh[i][j] = vh[i][j] 
        - dt * (
          vhmx[i][j] * vhmx[i][j]  / hmx[i][j]
        - vhmx[i][j-1] * vhmx[i][j-1]  / hmx[i][j-1]) / dx;
    }
    for (int i = 1; i < nx - 1; i++ )
    for (int j = 0; j < nx; j++)
    {
      h[i][j] = h[i][j] 
        - dt * ( vhmz[i][j] - vhmz[i-1][j] ) / dx;
      uh[i][j] = uh[i][j] 
        - dt * (
          uhmz[i][j] * uhmz[i][j]  / hmz[i][j]
        - uhmz[i-1][j] * uhmz[i-1][j]  / hmz[i-1][j]) / dx;
      vh[i][j] = vh[i][j] 
        - dt * ( damp*vh[i][j]+
          vhmz[i][j] * vhmz[i][j]  / hmz[i][j] + 0.5 * g * hmz[i][j] * hmz[i][j]
        - vhmz[i-1][j] * vhmz[i-1][j]  / hmz[i-1][j] - 0.5 * g * hmz[i-1][j] * hmz[i-1][j] ) / dx;
    }
  boundary_conditions(h, uh, vh); //<>//
}

void update(float dt){
  for (int i=0;i<(int)(dt/sim_dt);i++){
    waveEquation(sim_dt);
  }
}
float x1,x2;
PVector v1,v2,n;
void draw(){
  //pushMatrix();
  //translate(0,30,0);
  System.out.println("frame rate: "+frameRate);
  background(255);
  //camera.Update( dt);
  update(dt);
    noStroke();
    
    for (int i = 0; i < nx-1; i++) {
      for (int j = 0; j < nx-1; j++) { //<>//
        fill(176+(255-176)*(h[i][j]-10)/0.1, 196+(255-196)*(h[i][j]-10)/0.1, 222+(255-222)*(h[i][j]-10)/0.1);
        beginShape(TRIANGLE_STRIP);
        vertex(x[i][j],-h[i][j],z[i][j]);
        vertex(x[i][j+1],-h[i][j+1],z[i][j+1]);
        vertex(x[i+1][j],-h[i+1][j],z[i+1][j]);
        vertex(x[i+1][j+1],-h[i+1][j+1],z[i+1][j+1]);
        endShape(CLOSE);
      }
    }
  //  fill(176-(255-176), 196-(255-196), 222-(255-222)); //<>//
}

float[][] r8vec_linspace_new ( int n, float a_first, float a_last )
//
{
  float a[][] = new float[n][n];
  int i,j;

  if ( n == 1 )
  {
    a[0][0] = (( a_first + a_last ) / 2.0);
  }
  else
  {
    for ( i = 0; i < n; i++ )
     for ( j = 0; j < n; j++ )
    {
      a[i][j] = ((  ( n - 1 - i ) * a_first 
             +  (         i ) * a_last ) 
             /  ( n - 1     ));
    }
  }
  return a;
}

float[][] r8col_linspace_new ( int n, float a_first, float a_last )
//
{
  float a[][] = new float[n][n];
  int i,j;

  if ( n == 1 )
  {
    a[0][0] = (( a_first + a_last ) / 2.0);
  }
  else
  {
    for ( i = 0; i < n; i++ )
     for ( j = 0; j < n; j++ )
    {
      a[i][j] = ((  ( n - 1 - j ) * a_first 
             +  (         j ) * a_last ) 
             /  ( n - 1     ));
    }
  }
  return a;
}

void initial_conditions ( int nx, int nt, float x[][], float z[][], float t, float h[][], 
  float uh[][], float vh[][] )
{
  int i, j;
  float pi = PI;

  for ( i = 0; i < nx; i++ )
  for ( j = 0; j < nx; j++ )
  {
    h[i][j] = 10 + sin ( 2.0 * pi * (x[i][j]+z[i][j]) )*0.1 + cos ( 2.0 * pi * (x[i][j]+z[i][j]) )*0.1;
  }
  for ( i = 0; i < nx; i++ )
  for ( j = 0; j < nx; j++ )
  {
    uh[i][j] = 0.0;
    vh[i][j] = 0.0;
  }
  return;
}
