// credits to: https://www.shadertoy.com/view/XddGRS

// also have a look at
// https://glslsandbox.com/e#42786.3
// https://medium.com/@SereneBiologist/finding-beauty-in-bad-algorithms-799af003aee8
// https://www.shadertoy.com/results?query=newton+fractal

#ifdef GL_ES
precision highp float;
#endif

const int Iterations=16;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 function(vec2 z){
    //z^3-1
    return vec2(z.x*z.x*z.x-3.*z.x*z.y*z.y,3.*z.x*z.x*z.y-z.y*z.y*z.y)-vec2(1,0);
}

vec2 derivative(vec2 z){
    //derivative of z^3-1 which is 3z^2
    return 3.*vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
}

vec2 complexMultiply(vec2 a,vec2 b){
    return vec2(a.x*b.x-a.y*b.y,a.y*b.x+a.x*b.y);
}

vec2 complexDivide(vec2 a,vec2 b){
    return vec2(a.x*b.x+a.y*b.y,a.y*b.x-a.x*b.y)/(b.x*b.x+b.y*b.y);
}

vec2 Scale(vec2 p){
    return(6.*p-u_resolution.xy)/u_resolution.y;
}

//roots of z^3-1
const vec2 Root1=vec2(1,.00001);
const vec2 Root2=vec2(-.5,.86603);
const vec2 Root3=vec2(-.5,-.86603);

//color of roots
const vec3 color1=vec3(.75,.25,.25);
const vec3 color2=vec3(.25,.75,.25);
const vec3 color3=vec3(.25,.25,.75);

vec2 NewtonsMethod(vec2 z){
    for(int i=0;i<Iterations;i++){
        //zNext = z - f(z)/f'(z)
        // as we are analysing the polynomial z^3-1, and as the
        // derivative of z^3-1 is 3 * z^2
        // it means that zNext is equal to:
        //     1 - z^3
        // z - -------
        //     3 * z^2
        z=z-complexDivide(function(z),derivative(z));
        
        // to add interactity,try to use this instead of the previous line
        // z=z-complexMultiply(
            //     Scale(u_mouse.xy),
            //     complexDivide(function(z),derivative(z))
        // );
    }
    return z;
}

vec3 NewtonFractal(vec2 z){
    z=NewtonsMethod(z);
    
    float dr1=distance(z,Root1);
    float dr2=distance(z,Root2);
    float dr3=distance(z,Root3);
    
    return normalize(color1/dr1+color2/dr2+color3/dr3);
}

void main(){
    vec2 coord=(2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;
    gl_FragColor=vec4(NewtonFractal(coord),1.);
}