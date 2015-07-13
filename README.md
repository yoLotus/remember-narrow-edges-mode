# remember-narrow-edges-mode
Each time a buffer is narrowed with region active, their point and mark are recorded for this buffer. The next time this same buffer is narrowed without region active this time, the point and mark used for the narrow are the point and mark used when region was active for the very first narrowing.
