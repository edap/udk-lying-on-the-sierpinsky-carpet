#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

// map the screen resolution to a smaller canvas
const float minY=-1.;
const float maxY=1.;
const float minX=-1.5;
const float maxX=1.5;

void main(){
    vec2 vPos=vec2(
        gl_FragCoord.x*(maxX-minX)/u_resolution.x+minX,
        gl_FragCoord.y*(maxY-minY)/u_resolution.y+minY
    );
    gl_FragColor=vec4(vPos.x,vPos.y,0.,1.);
}