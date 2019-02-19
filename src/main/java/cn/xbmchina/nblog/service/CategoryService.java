package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.entity.Category;
import cn.xbmchina.nblog.entity.Special;
import cn.xbmchina.nblog.repository.CategoryMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;


    public int addCategory(Category category) {

        if (category != null) {
            Category byCondition = categoryMapper.selectByCondition(category);
            if (byCondition == null){
                category.setCreateTime(new Date());
                category.setUpdateTime(new Date());
                return categoryMapper.addCategory(category);
            }else{
                return categoryMapper.updateCategory(category);
            }
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


    public PageResult<Category> getList(Category category, Integer pageNum, Integer pageSize) {

        if (pageNum == null || pageSize == null) {
            pageNum = 1;
            pageSize = 10;
        }

        PageHelper.startPage(pageNum,pageSize);
        List<Category> list = categoryMapper.getList(category);
        PageInfo<Category> infos = new PageInfo<>(list);
        PageResult<Category> result = new PageResult<>();
        result.setPageNum(infos.getPageNum());
        result.setPageSize(infos.getPageSize());
        result.setTotal(infos.getTotal());
        result.setData(infos.getList());

        return result;

    }
}
