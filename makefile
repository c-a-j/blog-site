build:
	make github && make clean

github: 
	hugo --environment github
	rsync -avu --delete\
	   --exclude ".git*"\
	   ~/hugo/work-blog-site/docs/ ~/hugo/site/
	find ~/hugo/site -type f -exec sed -i 's|href="/"|href="https://code.fs.usda.gov/pages/clint-jordan/site"|g' {} +
	find ~/hugo/site -type f -exec sed -i 's|src="/images/|src="/pages/clint-jordan/site/images/|g' {} +

clean:
	rm -rf ~/hugo/work-blog-site/docs

