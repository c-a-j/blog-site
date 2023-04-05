personal:
	make github-p && make clean-p

github-p: 
	hugo --environment github-p
	rsync -avu --delete\
	   --exclude ".git*"\
	   ~/hugo/blog-site/docs-p/ ~/hugo/c-a-j.github.io/
	git -C ~/hugo/c-a-j.github.io/ add --all
	git -C ~/hugo/c-a-j.github.io/ commit -m "$$(date +"%Y-%b-%d_%H%M_%Z")"
	git -C ~/hugo/c-a-j.github.io/ push

clean-p:
	rm -rf ~/hugo/blog-site/docs-p

work:
	make github-w && make clean-w

github-w: 
	hugo --environment github-w
	rsync -avu --delete\
	   --exclude ".git*"\
	   ~/hugo/blog-site/docs-w/ ~/hugo/site/
	find ~/hugo/site -type f -exec sed -i 's|href="/"|href="https://code.fs.usda.gov/pages/clint-jordan/site"|g' {} +
	find ~/hugo/site -type f -exec sed -i 's|src="/images/|src="/pages/clint-jordan/site/images/|g' {} +
	find ~/hugo/site -type f -exec sed -i 's|href="/css/prism.css|href="/pages/clint-jordan/site/css/prism.css|g' {} +
	find ~/hugo/site -type f -exec sed -i 's|src="/js/prism.js|src="/pages/clint-jordan/site/js/prism.js|g' {} +
	git -C ~/hugo/site/ add --all
	git -C ~/hugo/site/ commit -m "$$(date +"%Y-%b-%d_%H%M_%Z")"
	git -C ~/hugo/site/ push


clean-w:
	rm -rf ~/hugo/blog-site/docs-w

