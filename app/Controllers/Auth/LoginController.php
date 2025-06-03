<?php

namespace App\Controllers\Auth;

use App\Models\User;
use App\Controllers\Controller;
use App\SessionGuard as Guard;

class LoginController extends Controller
{
	public function showLoginForm()
	{
		if (Guard::isUserLoggedIn()) {
			redirect('home');
		}

		$data = [
			'messages' => session_get_once('messages'),
			'old' => $this->getSavedFormValues(),
			'errors' => session_get_once('errors'),
			'error_wrong' => session_get_once('error_wrong')
		];

		$this->sendPage('auth/login', $data);
	}

	public function login()
{
    // Lấy thông tin người dùng từ form
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';

    $errors = [];
    $error_wrong = [];

    // Validate đầu vào
    if (empty($email) && empty($password)) {
        $errors['email'] = 'Bạn chưa nhập email.';
        $errors['password'] = 'Bạn chưa nhập mật khẩu.';
    } elseif (empty($email)) {
        $errors['email'] = 'Bạn chưa nhập email.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors['email'] = 'Email không đúng định dạng.';
    } elseif (empty($password)) {
        $errors['password'] = 'Bạn chưa nhập mật khẩu.';
    }

    // Nếu có lỗi validate → quay lại form
    if (!empty($errors)) {
        $this->saveFormValues($_POST, ['password']);
        redirect('login', [
            'errors' => $errors
        ]);
        return;
    }

    // Tìm user
    $user = User::where('email', $email)->first();

    if (!$user) {
        $error_wrong['email_password'] = 'Email hoặc mật khẩu không đúng.';
    } elseif (Guard::login($user, ['email' => $email, 'password' => $password])) {
        redirect('home'); // Đăng nhập thành công
        return;
    } else {
        $error_wrong['email_password'] = 'Mật khẩu không đúng.';
    }

    // Đăng nhập thất bại
    $this->saveFormValues($_POST, ['password']);
    redirect('login', [
        'error_wrong' => $error_wrong
    ]);
}


	public function logout()
	{
		Guard::logout();
		redirect('login');
	}

	protected function filterUserCredentials(array $data)
	{
		return [
			'email' => filter_var($data['email'], FILTER_VALIDATE_EMAIL),
			'password' => $data['password'] ?? null
		];
	}
}
