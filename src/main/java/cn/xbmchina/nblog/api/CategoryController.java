package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.entity.Category;
import cn.xbmchina.nblog.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/category")
@RestController
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @RequestMapping("/add")
    public ResponseResult addCategory(Category category) {

        int result = categoryService.addCategory(category);
        if (result >0){
            return ResponseResult.ofSuccess("操作成功！",null);
        }
        return ResponseResult.ofError("操作失败!");
    }


    @RequestMapping("/update")
    public ResponseResult updateCategory(Category category) {

        int result = categoryService.updateCategory(category);
        if (result >0){
            return ResponseResult.ofSuccess("操作成功！",null);
        }
        return ResponseResult.ofError("操作失败!");
    }



    @RequestMapping("/del")
    public ResponseResult delCategory(Long id) {

        int result = categoryService.deleteCategory(id);
        if (result >0){
            return ResponseResult.ofSuccess("操作成功！",null);
        }
        return ResponseResult.ofError("操作失败!");
    }

}
