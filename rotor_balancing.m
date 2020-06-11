clc;clear all;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This code computes masses for rotor balancing considering the phase % 
%   in the measurements: static balacing (one plane) and dynamic        %
%   balancing (two plane).                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Note: It should be pointed out we have assumed rotating Machines with rigid rotor.  
% Also, in to order to get good results, you should consider ...
% Author: Danilo Braga
% References:
% Rao, S. S. Mechanical vibrations. Ed. Pearson. 5th ed. ISBN 978-0-13-212819. 2011.
%   At the subsection: 9.4 Balancing of Rotating Machines

display(' ')
display('This code computes masses for static and')
display('dynamic rotor balancing')
display('---------- Rigid rotors ----------')
display(' ')
Tipo=input('Enter with 1 for static balacing or 2 for dynamic balancing: ');

% For static balacing case:
if Tipo == 1
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %            INPUT DATA - STATIC BALANCING             %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   v0=input('Enter with the vibration amplitude v0 (mm): ');
   f0=input('Enter with the vibration phase in same position f0 (degree): ');
   mt=input('Enter with the test mass (g): ');
   v1=input('Enter with the vibration amplitude v1 (mm): ');
   f1=input('Enter with the vibration phase in same position f1 (degree): ');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %     MASS CORRECTION CALCULATION AND ITS POSITION     %
   %         IN THE ROTOR (STATIC BALANCING)              %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   f0=pi*f0/180; f1=pi*f1/180;
   vef=sqrt(v0^2+v1^2-2*v1*v0*cos(f1-f0));
   
   % Angular position
   alfa=asin(v1*sin(f1-f0)/vef); alfa=alfa*180/pi;
   
   % Correction mass
   mc=mt*v0/vef; 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %           OUTPUT DATA - STATIC BALANCING             %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   display(' ')
   display(' ')
   display('STATIC BALANCING RESULTS')
   display(' ')
   display(' PLANO  MASSA   FASE');
   fprintf('   %1i     %4.2f  %5.2f\n',1,mc,alfa)
   display(' ')
   recalc_answer=input('Do you want recalculate the correction mass? (1) Yes (2) No. ');
   if recalc_answer == 1
      pa11=input('Enter with the angular position 1 (in degrees) at the correction plane: ');
      pa12=input(Enter with the angular position 2 (in degrees) at the correction plane: ');
      par11=pa11*pi/180; par12=pa12*pi/180;
      A1=[cos(par11) cos(par12);sin(par11) sin(par12)];
      B1=[mc*cos(alfa*pi/180);mc*sin(alfa*pi/180)];
      m1=A1\B1;
      display(' ')
      display('  PLANE  M1    PHASE1    M2    PHASE2');
      fprintf('   %1i     %4.2f  %3i      %4.2f  %3i\n',1,m1(1),pa11,m1(2),pa12)
   else
       display('  ')
       display('FINISHING STATIC BALANCING')
   end
else
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %          INPUT DATA - DYNAMIC BALANCING              %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   v10=input('Enter with the vibration amplitude v10 (mm): ');
   f10=input('Enter with the vibration phase in same position f10 (degrees): ');
   v11=input('Enter with the vibration amplitude v11 (mm): ');
   f11=input('Enter with the vibration phase in same position f11 (degrees): ');
   v12=input('Enter with the vibration amplitude v12 (mm): ');
   f12=input('Enter with the vibration phase in same position f12 (degrees): ');
   v20=input('Enter with the vibration amplitude v20 (mm): ');
   f20=input('Enter with the vibration phase in same position f20 (degrees): ');
   v21=input('Enter with the vibration amplitude v21 (mm): ');
   f21=input('Enter with the vibration phase in same position f21 (degrees): ');
   v22=input('Enter with the vibration amplitude v22 (mm): ');
   f22=input('Enter with the vibration phase in same position f22 (graus): ');
   mt1=input('Enter with the test mass at the plane 1 (g): ');
   f1=input('Enter with the angular position (in degrees) at the plane 1: ');
   mt2=input('Enter with the test mass at the plane 2 (g): ');
   f2=input('Enter with the angular position (in degrees) at the plane 2: ');
   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %             CONVERT PHASE TO RADIANS AND           %
   %               MOUNTING COMPLEX NUMBERS             %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %
   f10=pi*f10/180; f11=pi*f11/180; f12=pi*f12/180;
   f20=pi*f20/180; f21=pi*f21/180; f22=pi*f22/180;
   %
   V10=v10*(cos(f10)+i*sin(f10));
   V11=v11*(cos(f11)+i*sin(f11));
   V12=v12*(cos(f12)+i*sin(f12));
   V20=v20*(cos(f20)+i*sin(f20));
   V21=v21*(cos(f21)+i*sin(f21));
   V22=v22*(cos(f22)+i*sin(f22));
   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %           THE Q1 AND Q2 VECTORS CALCULATION        %
   %                   DYNAMIC BALANCING                %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %
   Q2=(V20*(V11-V10)-V10*(V21-V20))/((V21-V20)*(V12-V10)- ...
      (V22-V20)*(V11-V10));
   Q1=(-V10-Q2*(V12-V10))/(V11-V10);
   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %            MASS CORRECTION CALCULATION             %
   %                DYNAMIC BALANCING                   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %
   mc1=mt1*abs(Q1); mc2=mt2*abs(Q2);
   fc1=f1+phase(Q1)*180/pi; fc2=f2+phase(Q2)*180/pi;
   display(' ')
   display(' ')
   display('DYNAMIC BALANCING RESULTS')
   display(' ')
   display(' PLANE  MASS   PHASE');
   fprintf('   %1i     %4.2f  %5.2f\n',1,mc1,fc1)
   fprintf('   %1i     %4.2f  %5.2f\n',2,mc2,fc2)
   display(' ')
   recalc_answer=input('Do you want recalculate the correction mass? (1) Yes (2) No. ');
   if recalc_answer == 1
      plane_answer=input('Which plane?(1) Plane 1, (2) Plane 2 or (3) Both');
      if plane_answer == 3
         pa11=input('Enter with the angular position 1 (degrees) at the Plane 1: ');
         pa12=input('Enter with the angular position 2 (degrees) at the Plane 1: ');
         pa21=input('Enter with the angular position 1 (degrees) at the Plane 2: ');
         pa22=input('Enter with the angular position 2 (degrees) at the Plane 2: ');
         par11=pa11*pi/180; par12=pa12*pi/180;
         par21=pa21*pi/180; par22=pa22*pi/180;
         A1=[cos(par11) cos(par12);sin(par11) sin(par12)];
         B1=[mc1*cos(fc1*pi/180);mc1*sin(fc1*pi/180)];
         A2=[cos(par21) cos(par22);sin(par21) sin(par22)];
         B2=[mc2*cos(fc2*pi/180);mc2*sin(fc2*pi/180)];
         m1=A1\B1;
         m2=A2\B2;
         display(' ')
         display('  PLANE  M1    PHASE1    M2    PHASE2');
         fprintf('   %1i     %4.2f  %3i      %4.2f  %3i\n',1,m1(1),pa11,m1(2),pa12)
         fprintf('   %1i     %4.2f  %3i      %4.2f  %3i\n',2,m2(1),pa21,m2(2),pa22)
      elseif plane_answer == 1
         pa11=input('Enter with the angular position 1 (degrees) at the Plane 1: ');
         pa12=input('Enter with the angular position 2 (degrees) at the Plane 1: ');
         par11=pa11*pi/180; par12=pa12*pi/180;
         A1=[cos(par11) cos(par12);sin(par11) sin(par12)];
         B1=[mc1*cos(fc1*pi/180);mc1*sin(fc1*pi/180)];
         m1=A1\B1;
         display(' ')
         display('  PLANE  M1    PHASE1    M2    PHASE2');
         fprintf('   %1i     %4.2f  %3i      %4.2f  %3i\n',1,m1(1),pa11,m1(2),pa12)
      else
         pa21=input('Enter with the angular position 1 (degrees) at the Plane 2: ');
         pa22=input('Enter with the angular position 2 (degrees) at the Plane 2: ');
         par21=pa21*pi/180; par22=pa22*pi/180;
         A2=[cos(par21) cos(par22);sin(par21) sin(par22)];
         B2=[mc2*cos(fc2*pi/180);mc2*sin(fc2*pi/180)];
         m2=A2\B2;
         display(' ')
         display('  PLANE  M1    PHASE1    M2    PHASE2');
         fprintf('   %1i     %4.2f  %3i      %4.2f  %3i\n',2,m2(1),pa21,m2(2),pa22)
      end
   end
end
