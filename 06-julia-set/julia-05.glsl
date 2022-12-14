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
    //float angle=2.9;
    float angle=3.9*sin(u_time*.3);
    vec2 center=vec2(0.,0.);
    
    float ca=-.4;
    float cb=.6;
    
    vec2 mouse=u_mouse.xy/u_resolution.xy;
    float radius=mouse.x*2.;
    
    // we could also map the mouse y to the angle
    angle=(mouse.y*2.-1.)*3.9;
    
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
    // color can be much more complicated than what we did.
    
    // what if we plug n into a sin function?
    // if we devide the result by 2 and, and
    // we add 0.5, we should remain in the range 0-1, as cos and
    // sin are always returning values between -1 and 1
    // float r=.5-cos(n)/2.;
    // float g=.5-sin(n*9.)/2.;
    // float b=.5-cos(n*.7)/2.;
    
    // And if we multiply n by a big number?
    float r=.5-cos(n*154.)/2.;
    float g=.5-cos(n*146.)/2.;
    float b=.5-cos(n*62.)/2.;
    
    gl_FragColor=vec4(r,g,b,1.);
}