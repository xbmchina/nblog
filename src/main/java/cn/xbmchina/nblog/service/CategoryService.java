package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.entity.Category;
import cn.xbmchina.nblog.repository.CategoryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;


    public int addCategory(Category category) {

        if (category != null) {
           return categoryMapper.addCategory(category);
        }
        return 0;
    }


    public int updateCategory(Category category) {

        if (category != null) {
            return categoryMapper.updateCategory(category);
        }

        return 0;
    }


    public int deleteCategory(Long id) {

        if (id != null) {
            return categoryMapper.deleteCategory(id);
        }
        return 0;
    }


}
