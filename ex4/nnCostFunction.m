function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% J w/o regulation
y_matrix = eye(num_labels)(y,:);

X = [ones(m,1) X]; %add 1's column to the left X0
a1 = sigmoid(X*Theta1');
a1 = [ones(size(a1,1),1) a1];
hypo = sigmoid(a1*Theta2');

J = (1/m) * trace(-y_matrix' * log(hypo)-(1-y_matrix)'*log(1-hypo));
% J w/ regulation
Theta1_reg = Theta1;
Theta1_reg(:,1) = 0;
sum_Theta1_reg = sum(sum(Theta1_reg.^2));
Theta2_reg = Theta2;
Theta2_reg(:,1) = 0;
sum_Theta2_reg = sum(sum(Theta2_reg.^2));

J = J + (lambda/(2*m))*(sum_Theta1_reg+sum_Theta2_reg);

% Grad w/o regulation
delta3 = hypo - y_matrix;
delta2 = (delta3*Theta2_reg(:,2:end)).*sigmoidGradient(X*Theta1');
Delta2 = delta3'*a1;
Delta1 = delta2'*X;
Theta1_grad = (1/m)*(Delta1+lambda*Theta1_reg);
Theta2_grad = (1/m)*(Delta2+lambda*Theta2_reg);

















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
