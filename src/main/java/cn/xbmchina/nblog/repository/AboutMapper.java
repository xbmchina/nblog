package cn.xbmchina.nblog.repository;

import cn.xbmchina.nblog.entity.About;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface AboutMapper {


    @Insert(" INSERT INTO about " +
            " (title, logo, sub_title, keywords, description, site_email, site_icp, ping_sites, meta, remark)  " +
            " VALUES ( #{title}, #{logo}, #{subTitle}, #{keywords}, #{description}, #{siteEmail}, #{siteIcp}, #{pingSites}, #{meta}, #{remark}) ")
    int addAbout(About about);



    @Update(" UPDATE about  " +
            " SET  " +
            " title = #{title}, " +
            " logo = #{logo}, " +
            " sub_title = #{subTitle}, " +
            " keywords = #{keywords}, " +
            " description = #{description}, " +
            " site_email = #{siteEmail}, " +
            " site_icp = #{siteIcp}," +
            " ping_sites = #{pingSites}," +
            " meta = #{meta}," +
            " remark = #{remark}  " +
            " WHERE  " +
            " id = #{id} ")
    int updateAbout(About about);



    @Select( " SELECT id,title, logo, sub_title, keywords, description, site_email, site_icp, ping_sites, meta, remark " +
            " FROM about WHERE id = #{id} ")
    About selectAboutById(About about);

}
