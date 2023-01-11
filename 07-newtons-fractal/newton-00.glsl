// credits to https://www.shadertoy.com/view/ssBGWc

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
const float maxIterations=100.;

vec2 cmul(vec2 a,vec2 b){// complex multiplication
    return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);
}
vec2 cdiv(vec2 a,vec2 b){// complex division
    return vec2(a.x*b.x+a.y*b.y,-a.x*b.y+a.y*b.x)/(b.x*b.x+b.y*b.y);
}

vec2 fn(vec2 z){// f(z) = z^3 - 1
    return cmul(z,cmul(z,z))-vec2(1,0);
}

// this is the formula to get the derivative of the function z^3 - 1
vec2 dfn(vec2 z){// f'(z) = 3*z^2
    return cmul(vec2(3,0),cmul(z,z));
}

void main(){
    vec2 coord=(2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;// [-1,1] vertically
    float zoom=1.;
    
    //float zoom=pow(sin(u_time/5.+2.)+1.05,2.);
    vec2 z=coord/zoom;
    
    vec2 zPrev=z;
    float threshold=.00001;
    float i;
    
    // iterate: zNext = z - f(z)/f'(z)
    //     1 - z^3
    // z - -------
    //     3 * z^2
    // the next z is equal to the previous step over the slope of the function
    
    for(float n=0.;n<maxIterations;n++){
        z-=cdiv(fn(z),dfn(z));
        i=n;
        if(length(z-zPrev)<threshold)break;
        zPrev=z;
    }
    
    // this is a trick to position 3 roots
    float theta=atan(z.y,z.x);
    float rotation=mod(theta/6.2832+1.,1.);// [0,1]
    
    vec3 color;
    if(rotation<.33){
        color=vec3(1,0,0);
    }else if(rotation<.66){
        color=vec3(0,1,0);
    }else{
        color=vec3(0,0,1);
    }
    // set intensity based on how fast the solution was found
    float intensity=1./log(i);
    
    gl_FragColor=vec4(color*intensity,1);
}

