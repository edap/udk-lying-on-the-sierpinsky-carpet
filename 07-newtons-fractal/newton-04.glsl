// credits to https://codepen.io/p3xx/pen/EJGvwr

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

const int maxIterations=800;
const float minY=-1.;
const float maxY=1.;
const float minX=-1.5;
const float maxX=1.5;

// Hyperboloc functions from https://machinesdontcare.wordpress.com/2008/03/10/glsl-cosh-sinh-tanh/

/// COSH Function (Hyperbolic Cosine)
float cosh(float val)
{
    float tmp=exp(val);
    float cosH=(tmp+1./tmp)/2.;
    return cosH;
}

// TANH Function (Hyperbolic Tangent)
float tanh(float val)
{
    float tmp=exp(val);
    float tanH=(tmp-1./tmp)/(tmp+1./tmp);
    return tanH;
}

// SINH Function (Hyperbolic Sine)
float sinh(float val)
{
    float tmp=exp(val);
    float sinH=(tmp-1./tmp)/2.;
    return sinH;
}

// Complex Number math by julesb
// https://github.com/julesb/glsl-util

#define PI 3.14159265

#define cx_mul(a,b)vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x)
#define cx_div(a,b)vec2(((a.x*b.x+a.y*b.y)/(b.x*b.x+b.y*b.y)),((a.y*b.x-a.x*b.y)/(b.x*b.x+b.y*b.y)))
#define cx_modulus(a)length(a)
#define cx_conj(a)vec2(a.x,-a.y)
#define cx_arg(a)atan2(a.y,a.x)
#define cx_sin(a)vec2(sin(a.x)*cosh(a.y),cos(a.x)*sinh(a.y))
#define cx_cos(a)vec2(cos(a.x)*cosh(a.y),-sin(a.x)*sinh(a.y))

vec2 cx_sqrt(vec2 a){
    float r=sqrt(a.x*a.x+a.y*a.y);
    float rpart=sqrt(.5*(r+a.x));
    float ipart=sqrt(.5*(r-a.x));
    if(a.y<0.)ipart=-ipart;
    return vec2(rpart,ipart);
}

vec2 cx_tan(vec2 a){return cx_div(cx_sin(a),cx_cos(a));}

vec2 cx_log(vec2 a){
    float rpart=sqrt((a.x*a.x)+(a.y*a.y));
    float ipart=atan(a.y,a.x);
    if(ipart>PI)ipart=ipart-(2.*PI);
    return vec2(log(rpart),ipart);
}

vec2 cx_mobius(vec2 a){
    vec2 c1=a-vec2(1.,0.);
    vec2 c2=a+vec2(1.,0.);
    return cx_div(c1,c2);
}

vec2 cx_z_plus_one_over_z(vec2 a){
    return a+cx_div(vec2(1.,0.),a);
}

vec2 cx_z_squared_plus_c(vec2 z,vec2 c){
    return cx_mul(z,z)+c;
}

vec2 cx_sin_of_one_over_z(vec2 z){
    return cx_sin(cx_div(vec2(1.,0.),z));
}

////////////////////////////////////////////////////////////
// end Complex Number math by julesb
////////////////////////////////////////////////////////////

// From Stackoveflow
// http://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
vec3 hsv2rgb(vec3 c)
{
    vec4 K=vec4(1.,2./3.,1./3.,3.);
    vec3 p=abs(fract(c.xxx+K.xyz)*6.-K.www);
    return c.z*mix(K.xxx,clamp(p-K.xxx,0.,1.),c.y);
}

// My (Johan Karlsson) own additions to complex number math
#define cx_sub(a,b)vec2(a.x-b.x,a.y-b.y)
#define cx_add(a,b)vec2(a.x+b.x,a.y+b.y)
#define cx_abs(a)sqrt(a.x*a.x+a.y*a.y)
vec2 cx_to_polar(vec2 a){
    float phi=atan(a.x,a.y);
    float r=sqrt(a.x*a.x+a.y*a.y);
    return vec2(r,phi);
}

// End utils, here comes the actual fractal

// sin(z) - 2
vec2 f(vec2 z){
    vec2 sinz=cx_sin(z);
    vec2 sinzminustwo=vec2(sinz.x-2.,sinz.y);
    return sinzminustwo;
}

// f(z) derivated
// cos(z)
vec2 fPrim(vec2 z){
    return cx_cos(z);
}

vec2 one=vec2(1,0);
vec3 newtonRapson(vec2 z){
    vec2 oldZ=z;
    float s=0.;
    for(int i=0;i<maxIterations;i++){
        z=cx_sub(z,cx_div(f(z),fPrim(z)));
        if(abs(oldZ.x-z.x)<.00001&&abs(oldZ.y-z.y)<.00001){
            break;
        }
        
        vec2 w=cx_div(one,cx_sub(oldZ,z));
        float wAbs=cx_abs(w);
        
        s+=exp(-wAbs);
        oldZ=z;
    }
    return vec3(s,cx_to_polar(z));
}

void main(){
    vec2 center=vec2(0.,0.);
    
    vec2 vPos=vec2(
        gl_FragCoord.x*(maxX-minX)/u_resolution.x+minX,
        gl_FragCoord.y*(maxY-minY)/u_resolution.y+minY
    );
    
    // animate
    // vec2 moved=vec2(vPos.x-1.,vPos.y-.7);
    // float cs=cos(u_time/5.);
    // float sn=sin(u_time/5.);
    // vPos=vec2(moved.x*cs-moved.y*sn,moved.x*sn+moved.y*cs);
    
    vec3 result=newtonRapson(vPos);
    float c=.9-result.x/float(maxIterations)*50.;
    
    // vec3 color=hsv2rgb(vec3(result.z+u_time/15.,1.,c));
    // gl_FragColor=vec4(color,1.);
    
    vec3 color=hsv2rgb(vec3(result.z+u_time/15.,1.,c));
    gl_FragColor=vec4(color,1.);
}