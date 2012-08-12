#encoding: utf-8
require 'nokogiri'
require 'preprocessing_stage/arabic_normalizer'

XML_FILE = File.join('', "/host/my lab/ubuntu files/arwiki-latest-pages-articles.xml")
LINK_PATTERN = /\[\[([^\[\]:]*)\]\]/

TASNEEF_PAGE = /^تصنيف:.*/
TAWDE7_PAGE = /^.* \(توضيح\)/ 
TITLE_IGNORE = [TASNEEF_PAGE, TAWDE7_PAGE] 

OlR_PAGE_TABLE=<<EOF
CREATE TABLE solr_page_tmp
  ( page_id INT(8) UNSIGNED NOT NULL,
    page_title VARCHAR(255) NOT NULL DEFAULT '',
    s_d_title VARCHAR(255) NOT NULL DEFAULT '',
    page_type TINYINT UNSIGNED NOT NULL DEFAULT 0,
    KEY (page_title),
    KEY (s_d_title)
  ) DEFAULT CHARSET=utf8
  ( SELECT page_id, CONVERT(page_title using 'utf8') as 'page_title', CONVERT(page_title using 'utf8') as 's_d_title' FROM page
      WHERE  page_namespace = 0 AND page_title NOT RLIKE '(_?توضيح_?)' AND page_is_redirect = 0
  )
EOF

SOlR_PAGE_TABLE_INSERT_SYNONYMS=<<EOF
INSERT INTO solr_page_tmp (page_id, page_title, s_d_title, page_type)
  (SELECT p.page_id, CONVERT(page.page_title using 'utf8') as 'page_title', p.syn_title, 1  FROM
     (SELECT redirect.rd_from, page.page_id, CONVERT(page.page_title using 'utf8') as 'syn_title' FROM redirect
        JOIN page ON redirect.rd_title = page.page_title
          WHERE page.page_namespace = 0 AND page.page_title NOT RLIKE '(_?توضيح_?)'
     ) p
     JOIN page ON p.rd_from = page.page_id WHERE page.page_namespace = 0 AND page.page_title NOT RLIKE '(_?توضيح_?)'
  )
EOF

# ignore diambig to disambig cases, almost 25 case
SOLR_PAGE_TABLE_INSERT_DISAMBIGS=<<EOF
INSERT INTO solr_page_tmp (page_id, page_title, s_d_title, page_type)
  (SELECT page.page_id, CONVERT(p.page_title using 'utf8') as 'page_title', CONVERT(p.pl_title using 'utf8') as 's_d_title', 2 FROM
    (SELECT REPLACE(page.page_title,'_(توضيح)','') AS 'page_title', pagelinks.pl_title FROM
       page JOIN pagelinks ON page.page_id = pagelinks.pl_from
          WHERE page.page_namespace = 0 AND pagelinks.pl_namespace = 0 AND page.page_title RLIKE '(_?توضيح_?)'
    ) p
    JOIN page ON page.page_title = p.pl_title WHERE page.page_namespace = 0 AND LOCATE(p.page_title, p.pl_title) <> 0 AND p.pl_title NOT RLIKE '(_?توضيح_?)'
  )
EOF