/*
    FUTURISTIC MACHINE
    
    Computer Graphics Term Project
    Dr. Xiao
    
    Authors: Saikishore Gowrishankar
             Mason McCargish

    Music Track: Final Fantasy V OST: Musica Machina

    All owned trademarks belong to their respective owners.
    Lawyers love tautologies.
*/
  
#include "colors.inc" 
#include "math.inc"  

//These are macros that are used in the program for various events
#macro rate() (abs(sin(192*clock))) #end                                    //The main sinusoidal signal that controls the movement of the gears and hammer          
#macro tick() #if(clock<(pi/192)) 0 #else int(clock/(pi/192)) #end #end     //Increments on every hammer event
#macro ROC() (192*cos(192*clock)*sin(192*clock))/(abs(sin(192*clock))) #end //The derivative of the rate() macro
#macro cog_rate() ((ROC()<0)?tick():rate() + tick()) #end                   //Cogwheel spin rate
#macro cog_spin() ((tick()<8)?0:cog_rate())#end                             //Cogwheel spin logic

//Declare two cameras
#declare still_cam = 
camera
{
    location <0,5,(-34/3)>
    look_at <0,4,1>
}

#declare intro_cam =
camera
{
    location <0,5,-3-100*clock>
    look_at <0,4,1>
}

//Preprocessed camera logic
#if (clock<(1/12)) camera{intro_cam}
#else camera{still_cam}
#end

//Clock dependent light source. Flashes red when the music plays an alarm sound (at particular intervals based on tick())
light_source
{
    <50,50,-50>
    ( ((tick()>39)&(tick()<43)) | ((tick()>43)&(tick()<47)) | ((tick()>47)&(tick()<51)) | ((tick()>51)&(tick()<55)) )
        ? <1,(192/pi)*(mod(clock,pi/192)),(192/pi)*(mod(clock,pi/192))>
        :White
}

//Clock dependent light source above the machine synchronized to music
#if((tick()>8) & mod(tick(),4)=3)
light_source
{
    <0,8,0>
    color White shadowless
    spotlight
    radius 15
    tightness 1
    point_at<0,0,0>
}
#end   

//Macro for creating a cogwheel
#macro Cogwheel(Rx,Ry,Rz, Tx, Ty, Tz, s, spin, c)
union
{
    difference
    {
        cylinder{<0,0,0>,<0,0.25,0>, 1} 
        cylinder{<0,-0.1,0>,<0,1,0>, 0.75}      
        pigment {c}
        finish{reflection .5} 
    }
    cylinder{<0,0,0>,<0,0.25,0>,0.1 pigment{c}}
    union
    {
        cylinder{<-1.25,0,0>,<1.25,0,0>,0.1 pigment{c}}
        cylinder{<0,0,1.25>,<0,0,-1.25>,0.1 pigment{c}}
        cylinder{<0,0,1.25>,<0,0,-1.25>,0.1 pigment{c} rotate <0,45,0>}
        cylinder{<0,0,1.25>,<0,0,-1.25>,0.1 pigment{c} rotate <0,-45,0>} 
        translate<0,0.125,0>
    } 
    rotate<0,spin,0>
    scale<s,s,s>  
    translate<Tx,Ty,Tz> 
    rotate <Rx,Ry,Rz>
    rotate <90,0,0>
    translate<0,1,0>
}     
#end  

//Make entire scene a union to allow translation of everything  
union
{

    //Floor
    plane 
    { 
        <0, 1, 0>, 0
        pigment {checker color DarkPurple, color Black}   
        finish{phong 1 metallic reflection 0.1}
        normal{dents 0.1 scale 0.1}
    }

    //Back wall
    plane 
    { 
        <0, 0, 1>, 10
        pigment {checker color DarkPurple, color Black}   
        finish{phong 1 metallic reflection 0.1}
        normal{dents 0.1 scale 0.1}
    
    }

    //Red hammer (moves on every tick)
    union
    {
        cylinder{<0,1,0>,<0,1,-4>,0.125 pigment{Red}}
        cylinder{<0,0,-4>,<0,1.5,-4>,0.5 pigment{Red}}
        rotate <45*abs(sin(192*clock)),0,0> 
        translate<2.1,0,2> 
    }

    //Blue hammer (moves after horns start playing in music)   
    union
    {
        cylinder{<0,1,0>,<0,1,-4>,0.125 pigment{SteelBlue}}
        cylinder{<0,0,-4>,<0,1.5,-4>,0.5 pigment{SteelBlue}}
        rotate <45*((tick()<28)? 0 : abs(sin((192/2)*clock)) ),0,0> 
        translate<-2.1,0,2> 
    }

    //Generate cogwheels. Some are dependent on the tick and some move continuously.
    //All cogwheels move only after the 8th downbeat (tick).    
    Cogwheel(0,0,0, 0,-0.25,0,0.75, 40*cog_spin(),Silver)        
    Cogwheel(90,0,0, 0,-1.25,-0.75,1, 40*cog_spin(),Silver)
    Cogwheel(0,0,0, 1.5,-0.1,-0.5, 0.4, ((tick()<8)?0:4000*clock),Gold) 
    Cogwheel(0,0,0, -1.5,-0.1,-0.5, 0.4, ((tick()<8)?0:2000*clock),Gold)
    Cogwheel(0,0,0, -1.3,1.9,-2, 0.5, 40*cog_spin(),Silver)
    Cogwheel(0,0,0, 1.3,1.9,-2, 0.5, 40*cog_spin(),Silver)
    Cogwheel(0,0,0, 0,1.9,-1.6, 0.3, ((tick()<8)?0:8000*clock),Gold)  
    Cogwheel(0,0,0, 0,1.9,-4.5, 0.3, ((tick()<8)?0:8000*clock),Gold)
    Cogwheel(0,0,0, 1.3,1.9,-4.3, 0.5, ((tick()<8)?0:4000*clock),Gold) 
    Cogwheel(0,0,0, -1.3,1.9,-4.3, 0.5, ((tick()<8)?0:2000*clock),Gold)

    //Machine base    
    union
    {
        box{<-2,0,0>, <2,2,2>}
        box{<-2,0,2>,<2,6,4> }
        pigment{ Gold }
        normal { dents 0.5 scale 0.1 }
        finish {metallic specular 1 ambient .2 diffuse .6 reflection .5}   
    }

    //Clock face    
    cylinder 
    { 
        <0, 0, 0>, <0, 0.1, 0>, 4
        rotate <90, 0, 0>
        pigment
        { 
          image_map{ png "img.png" map_type 0 once } 
          scale<8,8,1>
          translate<-4,-4,0>
        }
        scale<0.25,0.25,0.25>
        translate<0,4,1.99>     
    }

    //Clock hand (synchronized to music tick)    
    cylinder
    {
        <0,0,0>, <0,1,0>,0.03
        rotate<0,0,-30*tick()>
        translate<0,4,1.99>
    }

    //Logic that shakes the entire scene at a particular interval in the music
    translate<0,(( mod(tick(),2)=1 & (tick()>8) )?0.03*sin(100000*clock):0),0>
}

