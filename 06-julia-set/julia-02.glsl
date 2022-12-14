#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

// map the screen resolution to a smaller canvas
// todo: add color, add radius, add angle animation

const int iterations=500;
const float minY=-1.;
const float maxY=1.;
const float minX=-1.5;
const float maxX=1.5;

void main(){
    vec2 center=vec2(0.,0.);
    float ca=-.4;
    float cb=.6;
    
    // fractal code
    vec2 vPos=vec2(
        gl_FragCoord.x*(maxX-minX)/u_resolution.x+minX,
        gl_FragCoord.y*(maxY-minY)/u_resolution.y+minY
    );
    // define a point z on the complex plane
    vec2 z=center-(vPos);
    
    // current iteration n;
    float n=0.;
    
    for(int i=iterations;i>0;i--){
        // do you remember how to square a complex number?
        // (a+bi)^2 => aa-bb + 2abi
        float aa=z.x*z.x;
        float bb=z.y*z.y;
        float twoab=2.*z.x*z.y;
        // test if the point z is not diverging too much
        if(aa+bb>4.){
            n=float(i)/float(iterations);
            break;
        }
        // plug the formula adding c to the real part
        // and to the imaginary part of the complex
        // number z.
        z=vec2((aa-bb)+ca,twoab+cb);
    }
    gl_FragColor=vec4(vec3(1.-n),1.);
    //or
    //gl_FragColor=vec4(vec3(n),1.);
}