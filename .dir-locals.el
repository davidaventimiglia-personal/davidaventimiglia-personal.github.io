;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((eval . (set (make-local-variable 'my-project-path)
		      (file-name-directory
		       (let ((d (dir-locals-find-file "./")))
			 (if (stringp d) d (car d))))))
	 (eval . (set (make-local-variable 'org-publish-project-alist) `(("dventimiglia.github.io"
									  :exclude "^_|docs"
									  :recursive t
									  :auto-sitemap t
									  :sitemap-filename "index.html"
									  :sitemap-title ""
									  :html-preamble-format (("en" "<h1 class=\"title\">David A. Ventimiglia</h1>"))
									  :sitemap-sort-files anti-chronologically
									  :html-head-include-scripts nil
									  :html-validation-link nil
									  :html-html5-fancy t
									  :html-postamble nil
									  :html-head-include-default-style nil
									  :html-head "
<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\">
<style>
ul {
  list-style-type: none;
}
ul li {
  font-size: larger;
  font-weight: bolder;
}
ul li ul li {
  font-size: smaller;
  font-weight: lighter;
}
</style>
"
									  :sitemap-format-entry (lambda (file style project)
												  (cond ((org-publish-find-property file :date project)
													 (format "%s"
														 (org-publish-sitemap-default-entry file style project)))
													((directory-name-p file)
													 (upcase-initials (org-publish-sitemap-default-entry file style project)))
													(t
													 (org-publish-sitemap-default-entry file style project))))
									  :publishing-directory ,(format "%sdocs" my-project-path)
									  :base-directory ,(format "%s" my-project-path))))))))
