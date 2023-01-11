// credits to
// https://discourse.processing.org/t/developing-a-fractal-shader/24306

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define ITER 12
#define NEWTON 2// 2,3,4,5

uniform vec2 u_resolution;
uniform vec2 u_mouse;

//Complex Math:
vec2 cexp(in vec2 z){return vec2(exp(z.x)*cos(z.y),exp(z.x)*sin(z.y));}
vec2 clog(in vec2 z){return vec2(log(length(z)),atan(z.y,z.x));}
vec2 cinv(in vec2 a){return vec2(a.x,-a.y)/dot(a,a);}
vec2 cmul(in vec2 a,in vec2 b){return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);}
vec2 cdiv(in vec2 a,in vec2 b){return cmul(a,cinv(b));}
vec2 cpow(in vec2 a,in vec2 b){return cexp(cmul(b,clog(a)));}

//---------------------------------------------------------
vec2 newton(in vec2 z)
{
    for(int i=0;i<ITER;i++)
    {
        vec2 z2=cpow(z,vec2(2,0));
        vec2 z3=cpow(z,vec2(3,0));
        vec2 z4=cpow(z,vec2(4,0));
        vec2 z5=cpow(z,vec2(5,0));
        vec2 z6=cpow(z,vec2(6,0));
        vec2 z7=cpow(z,vec2(7,0));
        vec2 z8=cpow(z,vec2(8,0));
        
        //---> change z calculation by uncomment different lines
        #if NEWTON==2
        z-=cdiv(z3-1.,3.*z2);// original: z^3 - 1  / ( 3*z^2)
        #elif NEWTON==3
        z-=cdiv(z3-.5+.05*u_mouse.y,(.5+.01*u_mouse.x)*z2);// z^3 - my / (mx*z^2)
        #elif NEWTON==4
        z-=cdiv(z4-.5+.05*u_mouse.y,(.5+.01*u_mouse.x)*z3);// z^4 - my / (mx*z^3)
        #elif NEWTON==5
        z-=cdiv(z5-.5+.05*u_mouse.y,(.5+.1*u_mouse.x)*z4);// z^5 - my / (mx*z^4)
        #elif NEWTON==8
        z-=cdiv(z8-.5+.05*u_mouse.y,(.5+.1*u_mouse.x)*z7);// z^5 - my / (mx*z^4)
        #endif
    }
    return z;
}

vec3 hsb2rgb(in vec3 c){
    vec3 rgb=clamp(abs(mod(c.x*6.+vec3(0.,4.,2.),6.)-3.)-1.,0.,1.);
    rgb=rgb*rgb*(3.-2.*rgb);
    return c.z*mix(vec3(1.),rgb,c.y);
}

vec3 getColor(in float t){
    vec3 col=vec3(t,t,t);
    return hsb2rgb(col);
}
//---------------------------------------------------------
void main(void)
{
    vec2 uv=-1.+2.*gl_FragCoord.xy/u_resolution.xy;
    uv.x*=u_resolution.x/u_resolution.y;
    vec2 z=newton(uv);
    vec3 col=getColor(length(z));
    gl_FragColor=vec4(col,1.);
}

