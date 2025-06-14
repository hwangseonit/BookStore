<?php

namespace App\Controllers\Manage;

use App\Controllers\Controller;
use App\SessionGuard as Guard;
use App\Models\Product;
use App\Models\User;
use App\Models\ProductType;
use App\Models\TacGia;
use App\Models\NhaXuatBan;
use App\Models\Bill;
use App\Models\BillDetail;
use App\Models\Cart;
use Carbon\Carbon;

class ManagementController extends Controller
{
    public function __construct()
    {
        if (!Guard::isUserLoggedIn()) {
            redirect('home');
        }

        parent::__construct();
    }

    /*** MANAGE ALL PRODUCTS ***/
    public function getAllProducts()
    {
        $products_manage = Product::join('loaisach', 'loaisach.ma_loai_sach', '=', 'sach.ma_loai_sach')->orderBy('sach.ma_sach', 'ASC')->get();
        $this->sendPage('manage/manageProduct', [
            'products_manage' => $products_manage
        ]);
    }


    /*** SORT PRODUCT ***/
    public function sortAllProducts()
    {
        if (isset($_POST['sort-price'])) {
            $sort_price = $_POST['sort-price'];
            if ($sort_price == 1) {
                $old_selected = array("val" => "1");
                $this->sendPage('manage/manageProduct', [
                    'products_manage' => Product::join('loaisach', 'loaisach.ma_loai_sach', '=', 'sach.ma_loai_sach')
                        ->orderBy('ma_sach', 'ASC')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($sort_price == 2) {
                $old_selected = array("val" => "2");
                $this->sendPage('manage/manageProduct', [
                    'products_manage' => Product::join('loaisach', 'loaisach.ma_loai_sach', '=', 'sach.ma_loai_sach')
                        ->orderBy('gia_khuyen_mai', 'ASC')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($sort_price == 3) {
                $old_selected = array("val" => "3");
                $this->sendPage('manage/manageProduct', [
                    'products_manage' => Product::join('loaisach', 'loaisach.ma_loai_sach', '=', 'sach.ma_loai_sach')
                        ->orderBy('gia_khuyen_mai', 'DESC')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($sort_price == 4) {
                $old_selected = array("val" => "4");
                $this->sendPage('manage/manageProduct', [
                    'products_manage' => Product::join('loaisach', 'loaisach.ma_loai_sach', '=', 'sach.ma_loai_sach')
                        ->orderBy('sold', 'DESC')->get(),
                    'old_selected' => $old_selected
                ]);
            }
        }
    }

    /*** CREATE NEW PRODUCT ***/
    public function showCreatePage()
    {
        $last_product = $this->createNewProductId();

        $product_type = ProductType::all();
        $tacgia = TacGia::all();
        $nxb = NhaXuatBan::all();

        $this->sendPage('manage/create', [
            'errors' => session_get_once('errors'),
            'old' => $this->getSavedFormValues(),
            'ma_sp' => $last_product,
            'loai_sp' => $product_type,
            'tacgia' => $tacgia,
            'nxb' => $nxb
        ]);
    }

    public function createNewProductId()
    {
        $last_product = Product::latest('ma_sach')->first();
        $last_product_id = (int)trim($last_product['ma_sach'], "S");    //Bỏ "SP" trong mã sản phẩm và chuyển về kiểu int
        $last_product_id++;
        $new_product_id = "S" . $last_product_id;
        $last_product['ma_sach'] = $new_product_id;
        return $last_product;
    }

    public function createProduct()
    {
        $data = $this->filterProductData($_POST);
        $model_errors = Product::validate($data);
        $this->uploadImage();

        //Cập nhật lại giá khuyến mãi
        if ($data['khuyen_mai'] && $data['khuyen_mai'] >= 0) {
            $data['gia_khuyen_mai'] = $data['gia_sach'] - $data['gia_sach'] * ($data['khuyen_mai'] / 100);
        } else {
            $data['gia_khuyen_mai'] = $data['gia_sach'];
        }

        //Ngày tạo = hiện tại
        $data['created_at'] = Carbon::now()->tz('Asia/Ho_Chi_Minh');

        if (empty($model_errors)) {
            $product = new Product();
            $product->fill($data);
            $product->save();
            redirect('manageProduct');
        }

        // Lưu các giá trị của form vào $_SESSION['form']
        $this->saveFormValues($_POST);
        // Lưu các thông báo lỗi vào $_SESSION['errors']
        redirect('create', ['errors' => $model_errors]);
    }

    protected function filterProductData(array $data)
    {
        return [
            'ma_sach' => $data['ma_sach'] ?? null,
            'ten_sach' => $data['ten_sach'] ?? null,
            'gia_sach' => $data['gia_sach'] ?? null,
            'khuyen_mai' => $data['khuyen_mai'] ?? null,
            'ma_loai_sach' => $data['ma_loai_sach'] ?? null,
            'ma_tac_gia' => $data['ma_tac_gia'] ?? null,
            'ma_nxb' => $data['ma_nxb'] ?? null,
            'so_luong' => $data['so_luong'] ?? null,
            'sold' => 0,
            'hinh_anh' => basename($_FILES["hinh_anh"]["name"]) ?? null,
            'anh_1' => basename($_FILES["anh"]["name"][0]) ?? null,
            'anh_2' => basename($_FILES["anh"]["name"][1]) ?? null,
            'mo_ta' => $data['mo_ta'] ?? null
        ];
    }

    protected function uploadImage()
{
    $allow_type = ['jpg', 'png', 'jpeg'];
    $target_dir = ROOTDIR . "/public/img/product/";

    // Helper function to upload a file
    function uploadFile($file, $target_dir, $allow_type) {
        $target_file = $target_dir . basename($file["name"]);
        $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
        if (in_array($imageFileType, $allow_type) && $file["error"] === UPLOAD_ERR_OK) {
            move_uploaded_file($file["tmp_name"], $target_file);
        }
    }

    // Upload main image
    if (isset($_FILES["hinh_anh"])) {
        uploadFile($_FILES["hinh_anh"], $target_dir, $allow_type);
    }

    // Upload additional images
    if (isset($_FILES["anh"])) {
        foreach ($_FILES["anh"]["name"] as $index => $name) {
            if (!empty($name)) {
                uploadFile(['name' => $name, 'tmp_name' => $_FILES["anh"]["tmp_name"][$index], 'error' => $_FILES["anh"]["error"][$index]], $target_dir, $allow_type);
            }
        }
    }
}


    /*** UPDATE PRODUCT ***/
    public function showUpdatePage($productId)
    {
        $product = Product::where('sach.ma_sach', '=', $productId)->first();

        $product_type = ProductType::all();
        $tac_gia = TacGia::all();
        $nxb = NhaXuatBan::all();

        $this->sendPage('manage/update', [
            'errors' => session_get_once('errors_update'),
            'product' => $product,
            'old_value' => $this->getSavedUpdateFormValues(),
            'loai_sp' => $product_type,
            'tg' => $tac_gia,
            'nxb' => $nxb
        ]);
    }

    public function update($productId)
    {
        $product = Product::where('ma_sach', '=', $productId)->first();
        $data = $this->filterProductData($_POST);
        $model_errors = Product::validate($data);

        //Nếu không chọn ảnh cập nhật => không cập nhật ảnh (not bring $data['hinh_anh'] to fill function)
        //Input file ảnh có thể cập nhật hoặc không cập nhật => nếu không cập nhật, không báo lỗi input file image
        if (!$data['hinh_anh']) {
            unset($data['hinh_anh']);
            unset($model_errors['hinh_anh']);
        }

        if (!$data['anh_1']) {
            unset($data['anh_1']);
            unset($model_errors['anh_1']);
        }

        if (!$data['anh_2']) {
            unset($data['anh_2']);
            unset($model_errors['anh_2']);
        }

        //Không cập nhật lại Mã Sản Phẩm và Created_at và Số lượng sp đã bán
        unset($data['ma_sach']);
        unset($data['created_at']);
        unset($data['sold']);

        //Cập nhật lại giá khuyến mãi
        if ($data['khuyen_mai'] && $data['khuyen_mai'] >= 0) {
            $data['gia_khuyen_mai'] = $data['gia_sach'] - $data['gia_sach'] * ($data['khuyen_mai'] / 100);
        } else {
            $data['gia_khuyen_mai'] = $data['gia_sach'];
        }

        if (empty($model_errors)) {
            $product->update($data);
            $product->save();
            redirect('../../manageProduct');
        }
        $this->saveUpdateFormValues($_POST);

        redirect('manage/' . $productId, ['errors_update' => $model_errors]);
    }


    /*** DELETE PRODUCT ***/
    public function delete($productId)
    {
        // Xóa tất cả sản phẩm này khỏi giỏ hàng trước
    Cart::where('ma_sach', '=', $productId)->delete();
        $product = Product::where('ma_sach', '=', $productId)->first();
    if ($product) {
        $product->delete();
    }
        redirect('../../manageProduct');
    }


    /*** SORT PRODUCT ***/
    public function sortAllUsers()
    {
        if (isset($_POST['sort-user'])) {
            $sort_user = $_POST['sort-user'];
            if ($sort_user == 1) {
                $old_selected = array("val" => "1");
                $this->sendPage('manage/users', [
                    'users_manage' => User::all(),
                    'old_user_selected' => $old_selected
                ]);
            } else if ($sort_user == 2) {
                $old_selected = array("val" => "2");
                $this->sendPage('manage/users', [
                    'users_manage' => User::orderBy('id', 'ASC')->get(),
                    'old_user_selected' => $old_selected
                ]);
            } else if ($sort_user == 3) {
                $old_selected = array("val" => "3");
                $this->sendPage('manage/users', [
                    'users_manage' => User::orderBy('id', 'DESC')->get(),
                    'old_user_selected' => $old_selected
                ]);
            } else if ($sort_user == 4) {
                $old_selected = array("val" => "4");
                $this->sendPage('manage/users', [
                    'users_manage' => User::orderBy('created_at', 'DESC')->get(),
                    'old_user_selected' => $old_selected
                ]);
            }
        }
    }


    /*** MANAGE ALL USERS ***/
    public function getAllUsers()
    {
        $users_manage = User::all();
        $this->sendPage('manage/users', [
            'users_manage' => $users_manage
        ]);
    }

    /*** UPDATE USER'S ACCOUNT ***/
    protected function filterUserData(array $data)
    {
        return [
            'name' => $data['name'] ?? null,
            'email' => filter_var($data['email'], FILTER_VALIDATE_EMAIL),
            'phone' => $data['phone'] ?? null,
            'address' => $data['address'] ?? null,
        ];
    }

    public function userInfo()
    {
        $user = User::where('id', $_GET['userId'])->first();

        $this->sendPage('manage/userInfo', [
            'errors' => session_get_once('errors_update'),
            'user' => $user,
            'old_value' => $this->getSavedUpdateFormValues(),
        ]);
    }

    public function updateUser()
    {
        $user = User::where('id', $_POST['id'])->first();
        $data = $this->filterUserData($_POST);
        $model_errors = User::validateUpdate($data);
        if (!$data['email'] || $data['email']== $user->email) {
            unset($data['email']);
            unset($model_errors['email']);
        }
        if (empty($model_errors)) {
            $user->update([
                'name' => $_POST['name'],
                'email' => $_POST['email'],
                'phone' => $_POST['phone'],
                'address' => $_POST['address'],
            ]);
            redirect('home');
        }
        
        $this->saveUpdateFormValues($_POST);
        redirect('userInfo?userId=' . $user->id, ['errors_update' => $model_errors]);
    }

    /*** UPDATE USER'S ACCOUNT ***/
    protected function filterPassData(array $data)
    {
        return [
            'password' => $data['password'] ?? null,
            'new_password' => $data['new_password'] ?? null,
			'password_confirmation' => $data['password_confirmation'] ?? null
        ];
    }

    public function passChange()
    {
        $user = User::where('id', $_GET['id'])->first();

        $this->sendPage('manage/passChange', [
            'errors' => session_get_once('errors_update'),
            'user' => $user,
            'old_value' => $this->getSavedUpdateFormValues(),
        ]);
    }

    public function updatePass()
    {
        $user = User::where('id', $_POST['id'])->first();
        $data = $this->filterPassData($_POST);
        $model_errors = User::validatePass($data);
        $verify = password_verify($data['password'], $user->password);
        if (!$verify){
            $model_errors['password'] = 'Mật khẩu không đúng';
        }
        if (empty($model_errors) && $verify) {
            $user->update([
                'password' => password_hash($_POST['new_password'], PASSWORD_DEFAULT),
            ]);
            redirect('home');
        }
        
        $this->saveUpdateFormValues($_POST);
        redirect('passChange?id=' . $user->id, ['errors_update' => $model_errors]);
    }

    /*** MANAGE ALL BILLS ***/
    public function manageBill()
    {
        $khach = User::where('email', Guard::user()->email)->first();
        $this->sendPage('manage/manageBill', [
            'bills' => Bill::join('users', 'users.id', '=', 'hoadon.id')->orderBy('ma_hoa_don', 'DESC')->get()
        ]);
    }

    public function manageDetailBill()
    {
        $this->sendPage('manage/manageDetailBill', [
            'bill' => BillDetail::join('sach', 'sach.ma_sach', '=', 'chitiethoadon.ma_sach')->where('ma_hoa_don', $_GET['mhd'])->get(),
            'billdetail' => Bill::where('ma_hoa_don', $_GET['mhd'])->get()
        ]);
    }

    public function cancelBill($billId)
    {
        $data['trang_thai'] = "Canceled";
        $bill = Bill::where('ma_hoa_don', '=', $billId)->first();
        $bill->update($data);
        redirect('../../manageBill');
    }

    public function send($billId)
    {
        $data['trang_thai'] = "sending";
        $bill = Bill::where('ma_hoa_don', '=', $billId)->first();
        $bill->update($data);
        redirect('../../manageBill');
    }

    /*** BILL FILTER ***/
    public function sortBill()
    {
        if (isset($_POST['bill-filter'])) {
            $filter_bill = $_POST['bill-filter'];
            if ($filter_bill == 1) {
                $old_selected = array("val" => "1");
                $this->sendPage('manage/manageBill', [
                    'bills' => Bill::orderBy('ma_hoa_don', 'DESC')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($filter_bill == 2) {
                $old_selected = array("val" => "2");
                $this->sendPage('manage/manageBill', [
                    'bills' => Bill::where('hoadon.trang_thai', '=', 'processing')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($filter_bill == 3) {
                $old_selected = array("val" => "3");
                $this->sendPage('manage/manageBill', [
                    'bills' => Bill::where('hoadon.trang_thai', '=', 'sending')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($filter_bill == 4) {
                $old_selected = array("val" => "4");
                $this->sendPage('manage/manageBill', [
                    'bills' => Bill::where('hoadon.trang_thai', '=', 'recieved')->get(),
                    'old_selected' => $old_selected
                ]);
            } else if ($filter_bill == 5) {
                $old_selected = array("val" => "5");
                $this->sendPage('manage/manageBill', [
                    'bills' => Bill::where('hoadon.trang_thai', '=', 'Canceled')->get(),
                    'old_selected' => $old_selected
                ]);
            }
        }
    }
}
