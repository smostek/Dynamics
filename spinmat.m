function P_AB = spinmat(i,alpha)
% A compression and improvement of rotx, roty, and rotz functions
arguments
    i (1,:) {mustBeInteger} % indices of the axes of rotation;
                            % inputting [3,2,3] creates a 3-2-3 rotation
                            % matrix assuming alpha complies
    alpha   % angles of rotation;
            % make sure the columns of alpha match the elements
            % of i. Any additional rows of alpha will create new
            % pages of rotation matrices
end

if isa(alpha,'symfun')
    alpha = formula(alpha);
end
[l,s] = size(alpha);
if s~=size(i,2)
    error('i and alpha must have same number of columns')
end
if l>1
    if isa(alpha,'sym')
        error('symbolic manipulation must occur within a single page')
    end
    a = reshape(alpha(:,1),[1 1 l]);
else
    a = alpha(1);
end

switch i(1)
    case 1 %rotation about x-axis
        P_AB = [ones(1,1,l),zeros(1,2,l); zeros(2,1,l),[cos(a),-sin(a);sin(a),cos(a)]];
    case 2 %rotation about y-axis
        P_AB = [cos(a),zeros(1,1,l),sin(a);zeros(1,1,l),ones(1,1,l),zeros(1,1,l);-sin(a),zeros(1,1,l),cos(a)];
    case 3 %rotation about z_axis
        P_AB = [[cos(a),-sin(a);sin(a),cos(a)],zeros(2,1,l);zeros(1,2,l),ones(1,1,l)];
end
if s>1
    if l>1
        P_AB = pagemtimes( P_AB, spinmat(i(2:s),alpha(:,2:s)) );
    else
        P_AB = P_AB*spinmat(i(2:s),alpha(:,2:s));
    end
end