#ifndef Global_INCLUDED
#define Global_INCLUDED

#define PI 3.14159274
#define Deg2Rad 0.0174532924
#define Rad2Deg 57.29578

// Math
inline fixed4 permute(fixed4 x) {
	return fmod(34.0 * pow(x, 2) + x, 289.0);
}
inline fixed2 fade(fixed2 t) {
	return 6.0 * pow(t, 5.0) - 15.0 * pow(t, 4.0) + 10.0 * pow(t, 3.0);
}
inline fixed4 taylorInvSqrt(fixed4 r) {
	return 1.79284291400159 - 0.85373472095314 * r;
}
inline fixed mod289(fixed x) {
	const float DIV_289 = 0.00346020761245674740484429065744;
	return x - floor(x * DIV_289) * 289.0;
}

inline fixed4 AlphaBlend(fixed4 dst, fixed4 src) {
	fixed dstFactor = dst.a * (1 - src.a);
	fixed resultAlpha = saturate(dstFactor + src.a);
	fixed srcFactor = src.a / resultAlpha;
	dst = fixed4(dst.rgb * dstFactor + src.rgb * srcFactor, resultAlpha);
	return saturate(dst);
}
inline float2 PolarCoordinate(float2 input) {
	float2 delta = input - 0.5;
	float radius = length(delta) * 2;
	float angle = atan2(delta.y, delta.x) * 1.0 / (PI * 2);
	return float2(radius, angle);
}

inline float FastNoise(float2 uv) {
	float2 p = frac(uv * float2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return frac(p.x * p.y);
}
inline fixed PerlinNoise2D(fixed2 P) {
	fixed4 Pi = floor(P.xyxy) + fixed4(0.0, 0.0, 1.0, 1.0);
	fixed4 Pf = frac(P.xyxy) - fixed4(0.0, 0.0, 1.0, 1.0);

	fixed4 ix = Pi.xzxz;
	fixed4 iy = Pi.yyww;
	fixed4 fx = Pf.xzxz;
	fixed4 fy = Pf.yyww;

	fixed4 i = permute(permute(ix) + iy);

	fixed4 gx = frac(i / 41.0) * 2.0 - 1.0;
	fixed4 gy = abs(gx) - 0.5;
	fixed4 tx = floor(gx + 0.5);
	gx = gx - tx;

	fixed2 g00 = fixed2(gx.x, gy.x);
	fixed2 g10 = fixed2(gx.y, gy.y);
	fixed2 g01 = fixed2(gx.z, gy.z);
	fixed2 g11 = fixed2(gx.w, gy.w);

	fixed4 norm = taylorInvSqrt(fixed4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
	g00 *= norm.x;
	g01 *= norm.y;
	g10 *= norm.z;
	g11 *= norm.w;

	fixed n00 = dot(g00, fixed2(fx.x, fy.x));
	fixed n10 = dot(g10, fixed2(fx.y, fy.y));
	fixed n01 = dot(g01, fixed2(fx.z, fy.z));
	fixed n11 = dot(g11, fixed2(fx.w, fy.w));

	fixed2 fade_xy = fade(Pf.xy);
	fixed2 n_x = lerp(fixed2(n00, n01), fixed2(n10, n11), fade_xy.x);
	fixed n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
	return (2.3 * n_xy) * 0.5 + 0.5;
}

//Coplor
fixed3 ColorToHSV(fixed3 color) {
	fixed4 K = fixed4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	fixed4 p = lerp(fixed4(color.bg, K.wz), fixed4(color.gb, K.xy), step(color.b, color.g));
	fixed4 q = lerp(fixed4(p.xyw, color.r), fixed4(color.r, p.yzx), step(p.x, color.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return fixed3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
fixed3 HSVToColor(fixed3 hsv) {
	fixed4 K = fixed4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	fixed3 p = abs(frac(hsv.xxx + K.xyz) * 6.0 - K.www);
	return hsv.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsv.y);
}
#endif