#ifndef Global_INCLUDED
#define Global_INCLUDED

#define PI 3.14159274
#define Deg2Rad 0.0174532924
#define Rad2Deg 57.29578

inline fixed4 AlphaBlend(fixed4 dst, fixed4 src) {
	fixed dstFactor = dst.a * (1 - src.a);
	fixed resultAlpha = saturate(dstFactor + src.a);
	fixed srcFactor = src.a / resultAlpha;
	dst = fixed4(dst.rgb * dstFactor + src.rgb * srcFactor, resultAlpha);
	return saturate(dst);
}
inline float2 PolarCoordinate(float2 uv) {
	float2 delta = uv - 0.5;
	float radius = length(delta) * 2;
	float angle = atan2(delta.y, delta.x) * 1.0 / 6.28;
	return float2(radius, angle);
}
inline float GetRandom(float seed) {
	float p = frac(seed * 123.34) + frac(seed * 456.78);
	return frac(p);
}
inline float SampleNoise(float2 uv) {
	float2 p = frac(uv * float2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return frac(p.x * p.y);
}
fixed4 HSVToColor(float h, float s, float v) {
	h = clamp(h, 0, 360);
	s = clamp(s, 0, 1);
	v = clamp(v, 0, 1);

	int hi = floor(h / 60) % 6;
	fixed f = h / 60 - floor(h / 60);
	fixed p = v * (1 - s);
	fixed q = v * (1 - f * s);
	fixed t = v * (1 - (1 - f) * s);

	fixed4 results[6] = {
		fixed4(v, t, p, 1),
		fixed4(q, v, p, 1),
		fixed4(p, v, t, 1),
		fixed4(p, q, v, 1),
		fixed4(t, p, v, 1),
		fixed4(v, p, q, 1)
	};

	return results[hi];
}
#endif