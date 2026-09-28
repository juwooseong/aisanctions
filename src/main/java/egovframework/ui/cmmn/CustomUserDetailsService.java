/**
 * 
 */
package egovframework.ui.cmmn;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.core.userdetails.UserDetailsService#
	 * loadUserByUsername(java.lang.String)
	 */
	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
		Collection<? extends GrantedAuthority> authorities;
		User userDetail = new User(userId, null, getAuthorities());
		return userDetail;
	}
	
	private List<GrantedAuthority> getAuthorities(){
		List<GrantedAuthority> list = new ArrayList<>();
		list.add(new SimpleGrantedAuthority("ROLE_USER"));
		return list;
	}

}
