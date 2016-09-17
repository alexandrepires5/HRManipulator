
/* ------ s8330m ------ */
//servo dimensions
s8330m_width = 29; //D
s8330m_height = 39;
s8330m_length = 59;
s8330m_total_length = 74;
s8330m_total_height = 57;
s8330m_bottom_cylinder_diameter = 0.384*s8330m_width; //sleeve
//s8330m_bottom_cylinder_height = 4.8; //sleeve
s8830m_bottomhinge_hole = s8330m_bottom_cylinder_diameter+0.4;

//servo_fixation_holes
s8330m_fixation_hole_x = 5;
s8330m_fixation_hole_y = 0;
s8330m_fixation_hole_z = 8.25;
s8330m_hole_diameter = 2.5;

//horn
s8330m_horn_height = 4;
s8330m_horn_1stcircle = 10;
s8330m_horn_2ndcircle = 15;
s8330m_horn_length = 34.5;
s8330m_horn_bigscrew = 10;
s8330m_horn_smallscrew = 2;
s8330m_horn_smallscrew_length =17;
s8330m_horn_head_d1 = 2;
s8330m_horn_head_d2 = 4;
    
/* ----------------------------- */

/* ------ if base_servo == "s8330m" ------*/
//hinge
support_z_hinge = s8330m_width + 0.9;
support_width_hinge = (s8330m_total_length - s8330m_length)/2 + 3;
servo_axis_clear = (s8330m_horn_length -s8330m_horn_1stcircle/2 + 3);
servo_HTot = s8330m_total_height + 2; //A
bigscrew = s8330m_horn_bigscrew;
smallscrew = s8330m_horn_smallscrew;
smallscrew_length = s8330m_horn_smallscrew_length;
smallscrew_head_d1 = s8330m_horn_head_d1;
smallscrew_head_d2 = s8330m_horn_head_d2;
//sleeve
support_width_sleeve = (s8330m_total_length - s8330m_length)/2 + 3;
servo_L = s8330m_length + 0.9;
servo_H = s8330m_height + 0.5;
support_z_sleeve = s8330m_width + 0.9;
servo_bottom_cylinder_diameter = s8330m_bottom_cylinder_diameter;
//servo_fixation_holes
servo_fixation_hole_x = s8330m_fixation_hole_x ;
servo_fixation_hole_y = s8330m_fixation_hole_y ;
servo_fixation_hole_z = s8330m_fixation_hole_z ;
servo_hole_diameter = 2;

/* ----------------------------- */
sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
sleeve_hinge_size = sleeve_hinge_dist*2;
hinge_sleeve_dist = 5;
hanger_height = support_width_hinge + 0.3;

module servo_sleeve(type = "side_hole", hole = "one", base_servo = "s8330m"){
 
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    #cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      #cube([9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  translate([-servo_L + 4.5,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  #cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module horn_single(horn = "sg90"){
    if(horn == "s8330m"){
        linear_extrude(height = s8330m_horn_height, center = false)
        hull(){
            translate([s8330m_horn_length -s8330m_horn_1stcircle/2, 0, 0]) circle(d = s8330m_horn_1stcircle, $fn = 32);
            circle(d = s8330m_horn_2ndcircle, $fn = 32);
        }
    }
    else if (horn == "mg946r"){
      linear_extrude(height = mg946r_horn_height, center = false)
      hull(){
       translate([mg946r_horn_length- mg946r_horn_1stcircle/2, 0, 0]) circle(d = mg946r_horn_1stcircle, $fn = 32);
       circle(d = mg946r_horn_2ndcircle, $fn = 32);
      }
    }
    else if (horn == "sg90"){
        linear_extrude(height = sg90_horn_height, center = false)
      hull(){
       translate([sg90_horn_length-sg90_horn_1stcircle/2, 0, 0]) circle(d = sg90_horn_1stcircle, $fn = 32);
       circle(d = sg90_horn_2ndcircle, $fn = 32);
      }
    }
}

module four_horn(horn = "s8330m"){
    for(i=[0:3])
    {
        rotate([0, 0, 90*i])
        horn_single(horn);
    }
}

module servo_hinge(hinge_servo = "s8330m"){

	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_single(hinge_servo);
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = s8830m_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}


module servo_hinge_base(hinge_servo = "s8330m"){

	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_single(hinge_servo);
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = s8830m_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
                
                translate([support_width_hinge,-servo_axis_clear+support_z_hinge/2+3.5,0]) rotate([0,90,0]) 
            hanger_base();
	  }
	
	}

}

module sleeve_hinge(horn, screw){
  difference(){
      union(){
         translate([-sleeve_hinge_size/2 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  #cube([sleeve_hinge_size, sleeve_hinge_dist + 2, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0])
  servo_hinge(horn);
    
  if(screw == "one") servo_sleeve(type = "side_hole", hole = "one");
      else servo_sleeve(type = "side_hole", hole = "two");
     }
       /*   
      // 1st screw
      
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);
      // 2nd screw
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))*2/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);*/
  }
  
}


module hinge_sleeve_alt_hinge(horn, screw){
  difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge(horn);  
    }

    for (i = [0:1]){
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - (i+0.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2/5*support_width_sleeve, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-16/16.5*servo_H, -servo_L - (i+0.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2/5*support_width_sleeve, h = 30, center = true, $fn =32);
    }
  }
}


module hinge_sleeve_alt_sleeve(horn, screw){
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
      if(screw == "one") servo_sleeve(type = "bottom", hole = "one");
      else servo_sleeve(type = "bottom_hole", hole = "two");
    }
    
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-16/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-16/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}
/*------------------------- Base -------------------------*/
module poly_base(base_servo){
    
    
    
BasePoints = [
  [  -support_z_hinge/2,  -support_z_hinge/2,  0 ],  //0
  [ support_z_hinge/2,  -support_z_hinge/2,  0 ],  //1
  [ support_z_hinge/2,  servo_axis_clear + support_width_hinge,  0 ],  //2
  [  -support_z_hinge/2,  servo_axis_clear + support_width_hinge,  0 ],  //3
  [  -support_z_hinge,  -support_z_hinge/2-support_width_hinge,  support_width_hinge ],  //4
  [ support_z_hinge,  -support_z_hinge/2-support_width_hinge,  support_width_hinge ],  //5
  [ support_z_hinge,  servo_axis_clear + 2*support_width_hinge,  support_width_hinge ],  //6
  [  -support_z_hinge,  servo_axis_clear + 2*support_width_hinge,  support_width_hinge ]]; //7
  
BaseFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
    difference(){
        union(){
            scale(v=[2,2,2]) polyhedron( BasePoints, BaseFaces );
    
            translate([0,0,2*support_width_hinge])
                linear_extrude(height = support_width_hinge/2, center = true)
                    scale(v=[2,2,2]) polygon(points = [ 
            [-support_z_hinge-10, -10-support_z_hinge/2-support_width_hinge],
            [support_z_hinge+10,  -support_z_hinge/2-support_width_hinge-10 ],
            [support_z_hinge+10,servo_axis_clear+10+ 2*support_width_hinge ],  
            [-support_z_hinge-10,servo_axis_clear+10+ 2*support_width_hinge]]);
        }
        
        //Support base screws
        for(i = [-1:2:1]){
            scale(v=[2,2,2])translate([i*support_z_hinge+i*5, -5-support_z_hinge/2-support_width_hinge, 0]) cylinder(d = 2.5, h = 15, $fn = 32);
            scale(v=[2,2,2])translate([i*support_z_hinge+i*5, servo_axis_clear+2*support_width_hinge+5, 0]) cylinder(d = 2.5, h = 15, $fn = 32);
        }
    }
}

module rect_base(){
    difference(){
        union(){
            linear_extrude(height = 5)
                polygon(points = [ 
                [-support_z_hinge/2-5,-support_z_hinge/2-5],
                [support_z_hinge/2+5, -support_z_hinge/2-5],
                [support_z_hinge/2+5,servo_axis_clear + support_width_hinge+5],
                [-support_z_hinge/2-5,servo_axis_clear+support_width_hinge+5]]);
        }
        
        //Support base screws
        for(i = [-1:2:1]){
            translate([i*support_z_hinge/2+i*2.5,-support_z_hinge/2-2.5, 0]) cylinder(d = 2.5, h = 15, $fn = 32);
            translate([i*support_z_hinge/2+i*2.5, servo_axis_clear+support_width_hinge+2.5, 0]) cylinder(d = 2.5, h = 15, $fn = 32);
        }
    }
}

module hanger_base(){
    difference(){
        union(){
            linear_extrude(height = 5)
                polygon(points = [ 
                [-support_z_hinge/2-5.15,-10],
                [support_z_hinge/2+5.15, -10],
                [support_z_hinge/2+5.15,servo_axis_clear+support_width_hinge+support_z_hinge/2],
                [-support_z_hinge/2-5.15,servo_axis_clear+support_width_hinge+support_z_hinge/2]]);
            
            
            /*translate([0,0,-hanger_height]) linear_extrude(height = hanger_height)
            polygon(points = [ 
                [-support_z_hinge/2-5.15,-10],
                [support_z_hinge/2+5.15, -10],
                [support_z_hinge/2+5.15,servo_axis_clear + support_width_hinge+support_z_hinge/2],
                [-support_z_hinge/2-5.15, servo_axis_clear+support_width_hinge+support_z_hinge/2]]);*/
            translate([0,0,-hanger_height-1]) linear_extrude(height = hanger_height+1)
            polygon(points = [ 
                [-support_z_hinge/2-5.15,-10],
                [support_z_hinge/2+5.15, -10],
                [support_z_hinge/2+5.15,servo_axis_clear + support_width_hinge+support_z_hinge/2],
                [-support_z_hinge/2-5.15, servo_axis_clear+support_width_hinge+support_z_hinge/2]]);
        }
        union(){
            //Support base screws
            for(i = [-1:1:1]){
                translate([i*support_z_hinge/2+i*2.25,-6.65, -hanger_height-1]) cylinder(d = 2.5, h = hanger_height+5+1, $fn = 32);
                translate([i*support_z_hinge/2+i*2.25, servo_axis_clear+support_width_hinge+support_z_hinge/2-3.35, -hanger_height-1]) cylinder(d = 2.5, h = hanger_height+5+1, $fn = 32);
                translate([i*support_z_hinge/2+i*2.25, (servo_axis_clear+support_width_hinge+support_z_hinge/2-10)/2, -hanger_height-1]) cylinder(d = 2.5, h = hanger_height+5+1, $fn = 32);
           }
           
           //hinge
            translate([0,0,-hanger_height]) linear_extrude(height = hanger_height)
        polygon(points = [ 
            [-support_z_hinge/2-0.15,-3.3],
            [support_z_hinge/2+0.15, -3.3],
            [support_z_hinge/2+0.15,servo_axis_clear + support_width_hinge+support_z_hinge/2],
            [-support_z_hinge/2-0.15, servo_axis_clear+support_width_hinge+support_z_hinge/2]]);
        
        translate([0,0,-hanger_height-1]) linear_extrude(height = hanger_height)
        polygon(points = [ 
            [-support_z_hinge/2-0.15+1,-3.3],
            [support_z_hinge/2+0.15-1, -3.3],
            [support_z_hinge/2+0.15-1,servo_axis_clear + support_width_hinge+support_z_hinge/2],
            [-support_z_hinge/2-0.15+1, servo_axis_clear+support_width_hinge+support_z_hinge/2]]);
        }
    }
}


module hanger_base_v2(){
    difference(){
        union(){
            linear_extrude(height = support_z_hinge/2 + servo_axis_clear+0.3)
                polygon(points = [ 
                [0,0],
                [support_width_hinge+0.3+1+5, 0],
                [support_width_hinge+0.3+1+5, support_z_hinge+0.3+10+2],
                [0, support_z_hinge+0.3+10+2],
                [0, support_z_hinge+0.3+5+1],
                [1, support_z_hinge+0.3+5+1],
                [1, support_z_hinge+0.3+5+2],
                [support_width_hinge+0.3+1, support_z_hinge+0.3+5+2],
                [support_width_hinge+0.3+1,5],
                [1,5],
                [1,5+1],
                [0,5+1] ]);
            translate([0,0,support_z_hinge/2 + servo_axis_clear+0.3]) cube([5+1+support_width_hinge+0.3,10+2+support_z_hinge+0.3,5],false);
        }
        union(){
            
        }
    }
}

module servo_base(base_servo, form_base, support_screws){ 
    
    difference(){
        union(){
            
            color("green") servo_hinge(base_servo);
             
            //visualization only //comment to export
            color("red") translate([servo_H - servo_HTot, -(servo_H + support_width_sleeve)-5.5,0])rotate([0,0,-90]) sleeve_hinge(base_servo, "two");
            
            //color("blue") translate([(17.1*abs(servo_axis_clear-servo_H)) - (servo_HTot + support_width_sleeve + support_width_hinge + servo_axis_clear + sleeve_hinge_dist), -(servo_L + 2 * support_width_sleeve + hinge_sleeve_dist), 0])  rotate([0,0,-90])hinge_sleeve_alt_sleeve ("s8330m", "two");
            
            if(form_base == "rect")
                translate([support_width_hinge,0,0]) rotate([0,90,0]) rect_base();
            else if(form_base == "poly")
                translate([support_width_hinge,0,0]) rotate([0,90,0]) poly_base(base_servo);
            else if(form_base == "hanger")
                translate([support_width_hinge,-servo_axis_clear+support_z_hinge/2-8,0]) rotate([0,90,0]) 
            hanger_base(base_servo);
            else if (form_base == "hanger2")
                translate([-1,servo_axis_clear,-support_z_hinge/2-5-1]) rotate([90,0,0])
            hanger_base_v2();
        }
        union(){
          
            // Support hinge Screws
            if(support_screws == "4")
                for(i = [1:1:2]){
                    translate([0, servo_axis_clear*i/3, support_z_hinge/3]) 
                    rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);
                    translate([0, servo_axis_clear*i/3, -support_z_hinge/3]) 
                    rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);
                }
            else if(support_screws == "2") {
            translate([0, servo_axis_clear/2, support_z_hinge/3]) 
                rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);
            translate([0, servo_axis_clear/2, -support_z_hinge/3]) 
                rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);
            }
            else if(support_screws == "3"){
                translate([0, servo_axis_clear/2, support_z_hinge/3]) 
                rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);
                translate([0, servo_axis_clear/2, -support_z_hinge/3]) 
                rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);
                translate([0, -support_z_hinge/3, 0]) rotate([0, 90, 0]) cylinder(d = 2.5, h = 25, $fn =32);    
            }
            else if(support_screws == "horizontal"){
                for(i = [1:1:2]){
                    translate([(hanger_height+5+1)/2, servo_axis_clear*(i*3-2)/5, -support_z_hinge/2-5.15]) 
                    cylinder(d = 2.5, h = support_z_hinge+15, $fn =32);
                }
            }
            
            
        }
    }
}

//hanger_base_v2();
//hanger_base();
//servo_hinge_base();
//servo_base("s8330m", "hanger2", "horizontal");



servo_hinge();