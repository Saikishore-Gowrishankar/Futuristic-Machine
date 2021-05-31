# Futuristic Machine
A raytraced animation of a machine, synchronized to a musical track. Video:

https://www.youtube.com/watch?v=iI3A4VBU074&ab_channel=KG.

# Explanation

This animation was created using the open-source raytracer programming language POVRay. Each frame was individually rendered at 1920x1080 resolution. Then all the frames were combined using ImageJ (a JAva-based image processing program) to create an AVI video. Using some post-processing, the video was then synchronized to an audio track (Final Fantasy V: Machina)

# Inspiration

This project was originally inspired by Bisqwit (Joel Yliluoma), who created the first animation using the same soundtrack. This project was largely inspired by his work, using the same music, but with a different animated machine. It was also inspired by MIDI music visualization, such as that made by Animusic (an American animation company that specializes in the 3D visualization of MIDI music). 

# Implementation

To synchronize the video to the audio, a mathematical model was used to represent events in the music. This part involved a lot of trial and error. A rudimentary model was calculated using the BPM (beats per minute) of the song, and it was represented using a global timer called tick() in the code, which goes off periodically. This tick() occurs on every downbeat in the music. Thus, all music-synchronized animations (such as the red alarm, or the movement of the cogs, or the beating of the hammer and the clock hand) were not based on physical time duration such as milliseconds, but rather based on ticks. This would make it much easier to change the overall speed of the program simply by changing the periodicity of the tick() sinusoid.
