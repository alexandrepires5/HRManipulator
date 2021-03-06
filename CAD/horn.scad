include <measures.scad>;

module horn_s8330m(){    
    linear_extrude(height = s8330m_horn_height, center = false)
    hull(){
        translate([s8330m_horn_length -s8330m_horn_1stcircle/2, 0, 0]) circle(d = s8330m_horn_1stcircle, $fn = 32);
        circle(d = s8330m_horn_2ndcircle, $fn = 32);
    }
}

module horn_s8330m_hinge(){    
    linear_extrude(height = s8330m_horn_height+2, center = false)
    hull(){
        translate([s8330m_horn_length -s8330m_horn_1stcircle/2+1, 0, 0]) circle(d = s8330m_horn_1stcircle+.5, $fn = 32);
        circle(d = s8330m_horn_2ndcircle+.5, $fn = 32);
    }
}

module horn_mg946r(){
    
  linear_extrude(height = mg946r_horn_height, center = false)
      hull(){
       translate([mg946r_horn_length- mg946r_horn_1stcircle/2, 0, 0]) circle(d = mg946r_horn_1stcircle, $fn = 32);
       circle(d = mg946r_horn_2ndcircle, $fn = 32);
      }

}

module horn_mg946r_hinge(){
    
  linear_extrude(height = mg946r_horn_height+2, center = false)
      hull(){
       translate([mg946r_horn_length- mg946r_horn_1stcircle/2+1, 0, 0]) circle(d = mg946r_horn_1stcircle+.5, $fn = 32);
       circle(d = mg946r_horn_2ndcircle+.5, $fn = 32);
      }

}

module horn_single_hk15328(){
  linear_extrude(height = hk15328_horn_height, center = false)
      hull(){
       translate([hk15328_horn_length- hk15328_horn_1stcircle/2, 0, 0]) circle(d = hk15328_horn_1stcircle, $fn = 32);
       circle(d = 11, $fn = 32);
      }
}

module horn_hk15328(){
    for(i=[0:1])
    {
        rotate([0, 0, 180*i])
        horn_single_hk15328();
    }
    linear_extrude(height = hk15328_horn_height, center = false) circle(d = hk15328_horn_2ndcircle, $fn = 32);
}



  

module horn_single_hd1160a(){
  linear_extrude(height = hd1160a_horn_height, center = false)
      hull(){
       translate([hd1160a_horn_length- hd1160a_horn_1stcircle/2, 0, 0]) circle(d = hd1160a_horn_1stcircle, $fn = 32);
       circle(d = hd1160a_horn_2ndcircle, $fn = 32);
      }
}

module horn_single_hd1160a_hinge(){
  linear_extrude(height = hd1160a_horn_height+2, center = false)
      hull(){
       translate([hd1160a_horn_length- hd1160a_horn_1stcircle/2+1, 0, 0]) circle(d = hd1160a_horn_1stcircle+0.5, $fn = 32);
       circle(d = hd1160a_horn_2ndcircle+0.5, $fn = 32);
      }
}

module horn_hd1160a(){
    for(i=[0:1])
    {
        rotate([0, 0, 180*i])
        horn_single_hd1160a();
    }
}

module horn_hd1160a_hinge(){
    for(i=[0:1])
    {
        rotate([0, 0, 180*i])
        horn_single_hd1160a_hinge();
    }
}


module horn_tss10mg_hinge(){
  linear_extrude(height = tss10mg_horn_height, center = false)
      hull(){
       translate([tss10mg_horn_length- tss10mg_horn_1stcircle/2+1, 0, 0]) circle(d = tss10mg_horn_1stcircle, $fn = 32);
       circle(d = tss10mg_horn_2ndcircle, $fn = 32);
      }
}
module horn_tss10mg(){
  linear_extrude(height = tss10mg_horn_height-2, center = false)
      hull(){
       translate([tss10mg_horn_length- tss10mg_horn_1stcircle/2, 0, 0]) circle(d = tss10mg_horn_1stcircle, $fn = 32);
       circle(d = tss10mg_horn_2ndcircle, $fn = 32);
      }
} 



module horn_max3002(){
  linear_extrude(height = max3002_horn_height, center = false)
      hull(){
       translate([max3002_horn_length- max3002_horn_1stcircle/2, 0, 0]) circle(d = max3002_horn_1stcircle, $fn = 32);
       circle(d = max3002_horn_2ndcircle, $fn = 32);
      }
}
module horn_max3002_hinge(){
  linear_extrude(height =max3002_horn_height+2, center = false)
      hull(){
       translate([max3002_horn_length- max3002_horn_1stcircle/2+1, 0, 0]) circle(d = max3002_horn_1stcircle+0.5, $fn = 32);
       circle(d = max3002_horn_2ndcircle+0.5, $fn = 32);
      }
}

module horn_single_tgys901d(){
    linear_extrude(height = 2.5, center = false)
      hull(){
       translate([20-6/2, 0, 0]) circle(d = 6, $fn = 32);
       circle(d = 9, $fn = 32);
      }  
}
module horn_single_tgys901d_hinge(){
  linear_extrude(height = 2.5, center = false){
      hull(){
       translate([20-6/2+1, 0, 0]) circle(d = 6+0.5, $fn = 32);
       circle(d = 11+0.5, $fn = 32);
      }
      circle(d = 15, $fn = 32);}
}
module horn_tgys901d_hinge(){
    for(i=[0:3])
    {
        rotate([0, 0, 90*i])
        horn_single_tgys901d_hinge();
    }
} 

module horn_tgys901d(){
    for(i=[0:3])
    {
        rotate([0, 0, 90*i])
        horn_single_tgys901d_hinge();
    }
}     
//horn_s8330m();
//translate([0,20,0]) 
//    horn_mg946r();
//translate([0,-20,0])
//    horn_hk15328();
//translate([20,0,0])
//    horn_tss10mg();
//translate([-20,0,0])
//    horn_hd1160a();
//horn_tgys901d();