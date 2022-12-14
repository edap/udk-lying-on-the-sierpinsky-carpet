#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

const int iterations=500;
const float minY=-1.;
const float maxY=1.;
const float minX=-1.5;
const float maxX=1.5;

void main(){
    float angle=3.9*sin(u_time*.3);
    vec2 center=vec2(0.,0.);
    float ca=-.4;
    float cb=.6;
    
    //let's zoom in moving the mouse from left to right
    vec2 mouse=u_mouse.xy/u_resolution.xy;
    float radius=mouse.x*2.;
    
    vec2 vPos=vec2(
        gl_FragCoord.x*(maxX-minX)/u_resolution.x+minX,
        gl_FragCoord.y*(maxY-minY)/u_resolution.y+minY
    );
    
    vec2 z=center-(vPos)*radius;
    float n=0.;
    
    for(int i=iterations;i>0;i--){
        float aa=z.x*z.x;
        float bb=z.y*z.y;
        float twoab=2.*z.x*z.y;
        
        if(aa+bb>4.){
            n=float(i)/float(iterations);
            break;
        }
        
        z=vec2((aa-bb)+ca*cos(angle),twoab+cb*-sin(angle));
    }
    gl_FragColor=vec4(vec3(1.-n),1.);
}