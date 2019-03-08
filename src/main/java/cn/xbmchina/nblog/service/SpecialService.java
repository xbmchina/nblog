package cn.xbmchina.nblog.service;

import cn.xbmchina.nblog.common.PageResult;
import cn.xbmchina.nblog.entity.Special;
import cn.xbmchina.nblog.repository.SpecialMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, rollbackForClassName = "Exception")
public class SpecialService {

    @Autowired
    private SpecialMapper specialMapper;


    public int save(Special special) {
        if (special != null) {
            if (special.getId() != null) {
                return specialMapper.updateSpecial(special);
            }else {
                return specialMapper.insertSpecial(special);
            }
        }
        return 0;
    }


    public int update(Special special) {
        return specialMapper.updateSpecial(special);
    }

    public int delete(Long id) {
        return specialMapper.deleteSpecial(id);
    }

    public PageResult<Special> getList(Special special, Integer pageNum, Integer pageSize) {

        if (pageNum == null || pageSize == null) {
            pageNum = 1;
            pageSize = 10;
        }

        PageHelper.startPage(pageNum,pageSize);
        List<Special> list = specialMapper.getList(special);
        PageInfo<Special> infos = new PageInfo<>(list);
        PageResult<Special> result = new PageResult<>();
        result.setPageNum(infos.getPageNum());
        result.setPageSize(infos.getPageSize());
        result.setTotal(infos.getTotal());
        result.setData(infos.getList());

        return result;
    }
}
