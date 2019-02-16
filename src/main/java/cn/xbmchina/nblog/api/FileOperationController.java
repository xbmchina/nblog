package cn.xbmchina.nblog.api;

import cn.xbmchina.nblog.common.ResponseResult;
import cn.xbmchina.nblog.util.UUIDUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@RestController
@RequestMapping("/file")
public class FileOperationController {


    private static String projectPath = StringUtils.substringBefore(System.getProperty("user.dir").replaceAll("\\\\", "/"),"/");
    private static  String uploadPath = "/blog/imgs/";
    /**
     * 自定义上传路径和下载路径进行上传
     * @param file 文件
     * @return
     * @throws Exception
     */
    @RequestMapping("/upload")
    public  ResponseResult upload(MultipartFile file) throws Exception {
        if (!file.isEmpty()){
            String filename = file.getOriginalFilename();
            String newFileName = UUIDUtil.getUUID()+".png";
            String path =  projectPath+uploadPath +newFileName;
            File dest = new File(path);
            if (!dest.getParentFile().exists()){
                dest.getParentFile().mkdirs();
            }
            file.transferTo(dest);
            return ResponseResult.ofSuccess("上传成功！","/file/download/"+newFileName);
        }
        return ResponseResult.ofError(500,"上传失败！",null);
    }




    /**
     * 按路径进行下载
     * @param path
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/download/{path}")
    public void download(@PathVariable String path, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            Path file = Paths.get( projectPath+uploadPath+path);
            if (Files.exists(file)) {
                String contentType = Files.probeContentType(Paths.get(path));
                response.setContentType(contentType);
                String filename = new String(file.getFileName().toString().getBytes("UTF-8"), "ISO-8859-1");
                response.addHeader("Content-Disposition", String.format("attachment; filename=\"%s\"", filename));
                response.setCharacterEncoding("UTF-8");
                Files.copy(file, response.getOutputStream());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }





}
