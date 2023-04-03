personal:
	make github-p && make clean-p

github-p: 
	hugo --environment github-p
	rsync -avu --delete\
	   --exclude ".git*"\
	   ~/hugo/blog-site/docs-p/ ~/hugo/c-a-j.github.io/
	cd ~/hugo/c-a-j.github.io/
	git add --all
	git commit -m "$$(date -u)"
	git push

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
	cd ~/hugo/site
	git add --all
	git commit -m "$$(date -u)"
	git push

clean-w:
	rm -rf ~/hugo/blog-site/docs-w

