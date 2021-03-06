include <measures.scad>
include <horn.scad>  

module motor_s8330m(){
    color("black") cube(size = [s8330m_width,s8330m_length,s8330m_partial_height], center = true);
    
    translate([0,0,(s8330m_height - s8330m_partial_height/2)+s8330m_height_fh/2]) 
        color("black") cube(size = [s8330m_width,s8330m_total_length,s8330m_height_fh], center = true);
    
    //shaft
    translate([0,s8330m_length*1/2-s8330m_length_to_shaft,s8330m_partial_height/2]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=s8330m_shaft_diameter, h=s8330m_shaft_height, $fn=32);     
    
    //horn
    translate([0,s8330m_length*1/2-s8330m_length_to_shaft,(s8330m_total_height- s8330m_partial_height/2-s8330m_horn_height/2)]) rotate([0,0,$t*180])
        color("black") horn_s8330m();
}

module motor_mg946r(){
    color("black") cube(size = [mg946r_width,mg946r_length,mg946r_partial_height], center = true);
    
    translate([0,0,(mg946r_height - mg946r_partial_height/2)+mg946r_height_fh/2]) 
         color("black") cube(size = [mg946r_width,mg946r_total_length,mg946r_height_fh], center = true);
    
    translate([0,mg946r_length*1/2-mg946r_length_to_shaft,mg946r_partial_height/2]) rotate([0,0,$t*180]) 
        color("white") cylinder(d=mg946r_shaft_diameter, h=mg946r_shaft_height);     
    
    translate([0,mg946r_length*1/2-mg946r_length_to_shaft,( mg946r_partial_height/2+mg946r_shaft_height)]) rotate([0,0,$t*180])
        color("black") horn_mg946r();
}

module motor_tgys901d(){
    color("black") cube(size = [tgys901d_width,tgys901d_length,tgys901d_partial_height], center = true);
    
    translate([0,0,(tgys901d_height - tgys901d_partial_height/2)+tgys901d_height_fh/2]) 
         color("black") cube(size = [tgys901d_width,tgys901d_total_length,tgys901d_height_fh], center = true);
    
    translate([0,tgys901d_length*1/2-tgys901d_length_to_shaft,tgys901d_partial_height/2]) rotate([0,0,$t*180]) 
        color("white") {cylinder(d=12, h = 2);
            cylinder(d=9, h=tgys901d_shaft_height);
            };     
    
    translate([0,tgys901d_length*1/2-tgys901d_length_to_shaft,( tgys901d_partial_height/2+tgys901d_shaft_height)]) rotate([0,0,$t*180])
        color("black") horn_tgys901d();
}

module motor_hk15328(){
    color("black") cube(size = [hk15328_width,hk15328_length,hk15328_partial_height], center = true);
    
    translate([0,0,(hk15328_height - hk15328_partial_height/2)+hk15328_height_fh/2]) 
         color("black") cube(size = [hk15328_width,hk15328_total_length,hk15328_height_fh], center = true);
    
    translate([0,hk15328_length*1/2-hk15328_length_to_shaft,hk15328_partial_height/2]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=hk15328_shaft_diameter, h=hk15328_shaft_height);     
    
    translate([0,hk15328_length*1/2-hk15328_length_to_shaft,(hk15328_partial_height/2+4)]) rotate([0,0,$t*180])
        color("black") horn_hk15328();
}

module motor_hd1160a(){
    color("black") cube(size = [hd1160a_width,hd1160a_length,hd1160a_partial_height], center = true);
    
    translate([0,0,(hd1160a_height - hd1160a_partial_height/2)+hd1160a_height_fh/2])
         color("black") cube(size = [hd1160a_width,hd1160a_total_length,hd1160a_height_fh], center = true);
    
    translate([0,hd1160a_length*1/2-9, hd1160a_partial_height/2+1]) rotate([0,0,0]) 
        color("yellow") cube(size = [hd1160a_width,18,2], center = true);   
    
    translate([0,hd1160a_length*1/2-hd1160a_length_to_shaft,hd1160a_partial_height/2+2]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=hd1160a_shaft_diameter, h=hd1160a_shaft_height);     
    
    translate([0,hd1160a_length*1/2-hd1160a_length_to_shaft,(hd1160a_partial_height/2+7)]) rotate([0,0,$t*180])
        color("black") horn_hd1160a();
}

module motor_tss10mg(){
    color("black") cube(size = [tss10mg_width,tss10mg_length,tss10mg_partial_height], center = true);
    
    translate([0,0,(tss10mg_height - tss10mg_partial_height/2)+tss10mg_height_fh/2]) 
         color("black") cube(size = [tss10mg_width,tss10mg_total_length,tss10mg_height_fh], center = true);
    
    translate([0,tss10mg_length*1/2-tss10mg_length_to_shaft, tss10mg_partial_height/2]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=tss10mg_width, h=2);  
    
    translate([0,tss10mg_length*1/2-tss10mg_length_to_shaft,tss10mg_partial_height/2+2]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=tss10mg_shaft_diameter, h=tss10mg_shaft_height);     
    
    translate([0,tss10mg_length*1/2-tss10mg_length_to_shaft,(tss10mg_partial_height/2+5)]) rotate([0,0,$t*180])
        color("black") horn_tss10mg();
}

module motor_max3002(){
    color("black") cube(size = [max3002_width,max3002_length,max3002_partial_height], center = true);
    
    translate([0,0,(max3002_height - max3002_partial_height/2)+max3002_height_fh/2]) 
         color("black") cube(size = [max3002_width,max3002_total_length,max3002_height_fh], center = true);
    
    translate([0,max3002_length*1/2-max3002_length_to_shaft, max3002_partial_height/2]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=max3002_width, h=3.5, $fn=32);  
    
    translate([0,max3002_length*1/2-max3002_length_to_shaft,max3002_partial_height/2+3.5]) rotate([0,0,$t*180]) 
        color("yellow") cylinder(d=max3002_shaft_diameter, h=max3002_shaft_height, $fn=32);     
    
    translate([0,max3002_length*1/2-max3002_length_to_shaft,(max3002_partial_height/2+6.5)]) rotate([0,0,$t*180])
        color("black") horn_max3002();
}

//motor_mg946r();
//rotate([90,0,0]) motor_s8330m();
//translate([0,0,100]) 
//rotate([90,0,0])    motor_s8330m();
//translate([-70,0,0])
//    motor_hk15328();
//translate([0,-70,0]);
//    motor_tss10mg();
//translate([0,70,0])
//    motor_hd1160a();
//motor_max3002();
//motor_tgys901d();