%%% Code developed by Aditya Natu. Designed mechanism verified against a prototype by Ankit Sharma. %%%

clc

a1=input('What is the initial inclination (degrees) of the imaginary line on the knuckle joining the pin joints connecting to the axle and tie rods? '); 
di=input('How much is max. turning angle for inner wheel (in degrees)? ');
w=input('How much is distance between two knuckle pins in mm? ');
c=input('How much is the distance between two axles in mm? '); 
r=input('What is the rack length  (joint to joint) in mm? ');
t=input('How much is the max. rack travel in either direction in mm? ');

Di=(pi*di)/180; 
Do=acot(cot(Di)+(w/c)); 
a=(pi*a1)/180; 

A = [1 2*sin(a - Di) 2*((w-r)/2 + t)*cos(a - Di); 1 2*sin(a + Do) 2*((w-r)/2 - t)*cos(a + Do); 1 2*sin(a) 2*((w-r)/2)*cos(a)];
B = [((w-r)/2 + t);((w-r)/2 - t);((w-r)/2)].^2;

Soln = A\B;

L = Soln(3);
D = Soln(2)/L;
M = sqrt(Soln(1) + D^2 + L^2);

fprintf('Steering arm length (straight-line distance between the joints connecting to the axle and tie rod) is %f mm \n', L);
fprintf('Tie rod length (joint to joint) is %f mm \n', M);
fprintf('Distance between the rack and the front axle is %f mm \n', D);

Ang_inn = linspace(0,Di,1000);
Ang_out_ideal = acot(w/c + cot(Ang_inn));

rack_travels = L*cos(a - Ang_inn) + sqrt(M^2 - (D - L*sin(a - Ang_inn)).^2) - (w-r)/2;
Bi = (w-r)/2 - rack_travels;

Ang_out_real = acos(Bi.*(Soln(3))./(sqrt((Soln(2)).^2 + (Bi.*Soln(3)).^2))) - a + acos((Bi.^2 - Soln(1))./(2*sqrt((Soln(2)).^2 + (Bi.*Soln(3)).^2)));

v=asin(D/(L+M));
md=(L+M)*cos(v)-((w-r)/2);

if t>md
    fprintf('This mechanism cannot be used');
else
    fprintf('This mechanism can be used');
end

figure
plot(Ang_inn, Ang_out_ideal)
hold on
plot(Ang_inn, Ang_out_real)
legend('Ideal curve','Actual curve');
xlabel('Inner angle (rad)');
ylabel('Outer angle (rad)');
hold off
grid on;
