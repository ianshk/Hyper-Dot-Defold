varying highp vec2 var_texcoord0;

uniform lowp vec4 startColor;
uniform lowp vec4 endColor;

void main()
{
   // startColor = vec4(0.0, 0.0, 0.0, 1.0);
   // endColor = vec4(1.0, 0.0, 1.0, 1.0);

    vec2 res = vec2(1.0, 1.0); 
    vec2 uv = var_texcoord0.xy * res.xy - 0.1;

    gl_FragColor = endColor * (1.0 - uv.y) + startColor * uv.y;
}

